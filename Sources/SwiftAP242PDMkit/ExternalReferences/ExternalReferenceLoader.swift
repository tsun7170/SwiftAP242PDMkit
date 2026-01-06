//
//  ExternalReferenceLoader.swift
//  
//
//  Created by Yoshida on 2021/10/19.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242

public actor ExternalReferenceLoader: SDAI.Object {

	public var externalReferenceList: [ExternalReference] = []
	public var externalReferences: [String:ExternalReference] {
		let pairs = zip(externalReferenceList.map{$0.name}, externalReferenceList)
		return Dictionary(pairs) { (v1,v2) in return v1 }
	}

	public var sdaiModels: some Collection<SDAIPopulationSchema.SdaiModel> {
		let models = externalReferences.values
      .lazy.compactMap({$0.exchangeStructure?.sdaiModels})
      .joined()
		return models
	}
	
  private let repository: SDAISessionSchema.SdaiRepository
  private let schemaList: P21Decode.SchemaList
  private var monitorType: ActivityMonitor.Type?
	private var resolver: ForeignReferenceResolver
  private var serial: Int

  private func issueSerial() -> Int {
    serial += 1
    return serial
  }

	public init?(
		repository: SDAISessionSchema.SdaiRepository,
		schemaList: P21Decode.SchemaList,
		masterFile: URL,
    monitorType: ActivityMonitor.Type?,
		foreignReferenceResolver: ForeignReferenceResolver = ForeignReferenceResolver()
	)
	{
    self.repository = repository
    self.schemaList = schemaList
		self.monitorType = monitorType
		self.resolver = foreignReferenceResolver

    let serial0 = 0
    self.serial = serial0

    let master = ExternalReference(
      asTopLevel: masterFile,
      serial: serial0)

		self.externalReferenceList.append(master)
	}
	
	/// decode a tree of P21 exchange data files starting from the masterFile
	/// - Parameter transaction: RW transaction for SDAI-model construction
	/// 
	public func decode(
		transaction: SDAISessionSchema.SdaiTransactionRW
	) async
  {
    let monitor = monitorType?.init(for: externalReferenceList.first!, concurrently: false)

    guard let decoder =
            P21Decode.Decoder(
              output: repository,
              schemaList: schemaList,
              monitor: monitor,
              foreignReferenceResolver: resolver)
    else {
      SDAI.raiseErrorAndContinue(.SY_ERR, detail: "failed to create P21Decode.Decoder")
      return
    }

    var needToLoad = true
    while needToLoad {
      needToLoad = false

      for externalReference in externalReferenceList {
        if externalReference.status != .notLoadedYet { continue }

        let children = await load(
          externalReference: externalReference,
          transaction: transaction,
          monitor: monitor,
          resolver: resolver,
          decoder: decoder)

        if !children.isEmpty {
          self.externalReferenceList += children
          needToLoad = true
        }
      }//for

    }//while
  }

  public func decodeConcurrently(
    transaction: SDAISessionSchema.SdaiTransactionRW
  ) async
  {
    let repository = self.repository
    let schemaList = self.schemaList
    let monitorType = self.monitorType
    let resolver = self.resolver

    await withTaskGroup(of: [ExternalReference].self) { taskGroup in
      for externalReference in externalReferenceList {
        if externalReference.status != .notLoadedYet { continue }

        addTask(externalReference: externalReference)

        for await children in taskGroup {
          self.externalReferenceList += children
          for child in children {
            addTask(externalReference: child)
          }
        }
      }

      func addTask(externalReference: ExternalReference) {
        taskGroup.addTask {
          let monitor = monitorType?.init(for: externalReference, concurrently: true)

          guard let decoder =
                  P21Decode.Decoder(
                    output: repository,
                    schemaList: schemaList,
                    monitor: monitor,
                    foreignReferenceResolver: resolver)
          else {
            SDAI.raiseErrorAndContinue(.SY_ERR, detail: "failed to create P21Decode.Decoder")
            return []
          }

          let children = await self.load(
            externalReference: externalReference,
            transaction: transaction,
            monitor: monitor,
            resolver: resolver,
            decoder: decoder)
          return children
        }
      }//func
    }//withTaskGroup
  }

  private var exchangeStructures: [DocumentSourceProperty:P21Decode.ExchangeStructure] = [:]

  private func register(
    exchange: P21Decode.ExchangeStructure,
    for key:DocumentSourceProperty
  ) -> P21Decode.ExchangeStructure?
  {
    if let registered = exchangeStructures[key] {
      return registered
    }
    exchangeStructures[key] = exchange
    return nil
  }

	/// load a specified external reference p21 data stream
	/// - Parameters:
	///   - externalReference: external reference to a p21 data stream
	///   - transaction: RW transaction for decoding action
	/// - Returns: array of ExternalReferences containing the found child data references.
	///
  nonisolated(nonsending)
	public func load(
		externalReference: ExternalReference,
		transaction: SDAISessionSchema.SdaiTransactionRW,
    monitor: ActivityMonitor?,
    resolver: ForeignReferenceResolver,
    decoder: P21Decode.Decoder
  ) async -> [ExternalReference]
	{
		monitor?.startedLoading(externalReference: externalReference)
		defer{ monitor?.completedLoading(externalReference: externalReference) }
		
		for sourceProperty in externalReference.sourceProperties {
			switch resolver.disposition(of: sourceProperty) {
				case .load:
          if let exchange = await exchangeStructures[sourceProperty] {
            let status = LoadingStatus.loaded(exchange)
            externalReference.status = status
            return []
          }

          let (status,schemaInstance) =
          await self.decodeExchangeStructure(
            from: sourceProperty,
            as: externalReference.name,
            transaction: transaction,
            resolver: resolver,
            decoder: decoder)

          externalReference.status = status

          guard case .loaded(let exchange) = status,
                let schemaInstance
          else { return [] }

          if let registered = await self.register(exchange: exchange, for: sourceProperty) {
            externalReference.status = .loaded(registered)
          }

          let children = await identifyExternalReferences(
            parent: externalReference,
            parentInstance: schemaInstance,
            monitor: monitor,
            resolver: resolver)

          return children

				case .suspendLoading:
					let status = LoadingStatus.loadPending
          externalReference.status = status
					return []

				case .referenceUnknown:
					continue
			}
		}
		let status = LoadingStatus.foreignReference
    externalReference.status = status
		return []
	}


  nonisolated(nonsending)
  private func decodeExchangeStructure(
    from sourceProperty: DocumentSourceProperty,
    as schemaInstanceName: String,
    transaction: SDAISessionSchema.SdaiTransactionRW,
    resolver: ForeignReferenceResolver,
    decoder: P21Decode.Decoder
  ) async -> (status:LoadingStatus,
        schemaInstance:SDAIPopulationSchema.SchemaInstance?)
  {
    guard let p21stream = resolver.characterSteam(from: sourceProperty)
    else {
      let status = LoadingStatus.inError(.referenceNotFound(sourceProperty))
      return (status, nil)
    }
    guard
      let models = decoder.decode(input: p21stream, transaction: transaction),
      let exchange = decoder.exchangeStructure
    else {
      let status = LoadingStatus.inError(.decoderError(decoder.error))
      return (status, nil)
    }

    guard let schemaInstance = transaction.createSchemaInstance(
      repository: decoder.repository,
      name: schemaInstanceName,
      schema: apPDM.schemaDefinition)
    else {
      let status = LoadingStatus.inError(.sdaiError(transaction.owningSession!.errors))
      return (status, nil)
    }

    for model in models {
      let _ = await transaction.addSdaiModel(
        instance: schemaInstance, model: model)
    }

    let status = LoadingStatus.loaded(exchange)
    return (status, schemaInstance)
  }

  nonisolated(nonsending)
	private func identifyExternalReferences(
		parent: ExternalReference,
		parentInstance: SDAIPopulationSchema.SchemaInstance,
    monitor: ActivityMonitor?,
    resolver: ForeignReferenceResolver
	) async -> [ExternalReference]
	{
		var children: [ExternalReference] = []

		for documentFile in documentFiles(in: parentInstance) {
			let child = ExternalReference(
        serial: await issueSerial(),
				upStream: parent,
				documentFile: documentFile,
				resolver: resolver)

			children.append(child)
		}
		
    monitor?.identified(children: children, originatedFrom: parent)

		return children
	}

}


