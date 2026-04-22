//
//  ExternalReferenceLoader.swift
//  
//
//  Created by Yoshida on 2021/10/19.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore


/// An actor responsible for loading and resolving external references to STEP P21 exchange data files,
/// building a collection of external references and managing decoding across potentially multiple files.
///
/// `ExternalReferenceLoader` coordinates the import of external resources, mapping their models into the
/// repository, handling dependencies between files, and facilitating concurrent or sequential decoding.
///
/// - Responsibilities:
///   - Maintains a list of external references and provides efficient lookup by name.
///   - Decodes a tree of P21 exchange data files, recursively discovering and registering child references.
///   - Supports both sequential and concurrent decoding of referenced files.
///   - Manages association of exchange structures and schema instances with their corresponding source documents.
///   - Coordinates progress monitoring and error reporting through an optional `ActivityMonitor`.
///
/// - Usage:
///   Initialize with a repository, schema list, master file URL, and (optionally) an activity monitor type
///   and a custom reference resolver. Call `decode(transaction:)` or `decodeConcurrently(transaction:)`
///   to import the referenced data streams into the repository.
///
/// - Thread Safety:
///   As an `actor`, all mutable state is safely isolated. Some methods are marked as `nonisolated` for
///   performance or architectural reasons (e.g., when interacting with shared or external resources).
///
/// - SeeAlso:
///   - `ExternalReference`
///   - `P21Decode/ExchangeStructure`
///   - `ActivityMonitor`
///   - `ForeignReferenceResolver`
///   - `SDAISessionSchema/SdaiRepository`
///   - `SDAIPopulationSchema/SchemaInstance`
///
public actor ExternalReferenceLoader: SDAI.Object {

  /// An ordered collection of all currently recognized external references within the import session.
  ///
  /// This array contains every `ExternalReference` discovered or registered by the loader, including the master
  /// file and any recursively identified child references. The order reflects the sequence in which references
  /// are recognized and appended, starting with the top-level reference.
  ///
  /// Each entry represents a distinct external data source (e.g., a STEP P21 file or dependent resource)
  /// whose presence may affect the decoding process and model population. The loader consults this list
  /// to determine which files still require loading, to manage dependencies, and to facilitate lookup or
  /// reporting tasks.
  ///
  /// - SeeAlso: `ExternalReference`, `externalReferences`
	public var externalReferenceList: [ExternalReference] = []

  /// A dictionary providing efficient lookup of all currently recognized external references by name.
  ///
  /// The keys are the unique names of external references (e.g., file or resource identifiers),
  /// and the values are the corresponding `ExternalReference` objects discovered or registered
  /// during the import session. The dictionary is constructed from the `externalReferenceList`,
  /// preserving only the first occurrence of each reference name.
  ///
  /// Use this property to quickly retrieve a specific external reference by name, or to enumerate
  /// all known references as a keyed collection. This facilitates dependency resolution,
  /// reporting, and model association tasks.
  ///
  /// - Note: The order of the dictionary does not reflect the chronological order of discovery.
  ///   For sequential ordering, use `externalReferenceList`.
  ///
  /// - SeeAlso: `externalReferenceList`, `ExternalReference`
	public var externalReferences: [String:ExternalReference] {
		let pairs = zip(externalReferenceList.map{$0.name}, externalReferenceList)
		return Dictionary(pairs) { (v1,v2) in return v1 }
	}

  /// A collection view aggregating all SDAI models discovered among the loaded external references.
  ///
  /// This computed property collects every `SDAIPopulationSchema.SdaiModel` present in the currently
  /// loaded external references, as recognized by the loader. For each `ExternalReference` that has
  /// completed loading and possesses an associated exchange structure, all of its SDAI models are
  /// extracted and returned as a single, lazily-evaluated collection.
  ///
  /// Use this property to iterate through all available models within the import session, regardless
  /// of their source file or hierarchical position. This is useful for broad queries, reporting,
  /// repository management, or any operation requiring access to all decoded models in the session.
  ///
  /// - Returns: A collection containing all `SDAIPopulationSchema.SdaiModel` instances loaded from
  ///            the referenced external structures, in an unspecified order.
  /// - SeeAlso: `externalReferences`, `ExternalReference.exchangeStructure`
	public var sdaiModels: some (Collection<SDAIPopulationSchema.SdaiModel> & Sendable) {
		let models = externalReferences.values
      .lazy.compactMap({$0.exchangeStructure?.sdaiModels})
      .joined()
		return Array(models)
	}

  public let umbrellaFolder: URL

  private let repository: SDAISessionSchema.SdaiRepository
  private let schemaList: P21Decode.SchemaList
  private var monitorType: ActivityMonitor.Type?
	private var resolver: ForeignReferenceResolver
  private var serial: Int

  private func issueSerial() -> Int {
    serial += 1
    return serial
  }

  /// Initializes a new `ExternalReferenceLoader` to manage the loading and resolution of external references
  /// from a STEP P21 master file, mapping the data into the specified repository using the provided schema list.
  ///
  /// - Parameters:
  ///   - repository: The `SdaiRepository` into which decoded models and schema instances will be imported.
  ///   - schemaList: The list of STEP schemas available for validation and decoding.
  ///   - masterFile: The URL of the top-level (master) P21 exchange data file to import.
  ///   - monitorType: An optional `ActivityMonitor.Type` for reporting progress and status during decoding.
  ///   - foreignReferenceResolver: An optional custom `ForeignReferenceResolver` to resolve file/document references.
  ///
  /// This initializer creates the root `ExternalReference` for the master file, prepares the loader's state,
  /// and configures the actor for subsequent decoding operations. Returns `nil` if initialization fails.
  ///
  /// - SeeAlso: `ExternalReference`, `SdaiRepository`, `ForeignReferenceResolver`, `ActivityMonitor`
	public init?(
		repository: SDAISessionSchema.SdaiRepository,
		schemaList: P21Decode.SchemaList,
		masterFile: URL,
    umbrellaFolder: URL,
    monitorType: ActivityMonitor.Type?,
		foreignReferenceResolver: ForeignReferenceResolver = ForeignReferenceResolver()
	)
	{
    let serial0 = 0
    guard let master = ExternalReference(
      asTopLevel: masterFile,
      serial: serial0,
      base: umbrellaFolder)
    else { return nil }

    self.repository = repository
    self.schemaList = schemaList
    self.umbrellaFolder = umbrellaFolder
    self.monitorType = monitorType
    self.resolver = foreignReferenceResolver
    self.serial = serial0
		self.externalReferenceList.append(master)
	}
	
  /// Decodes a hierarchy of STEP P21 exchange data files starting from the master file, recursively discovering and loading all external references into the repository.
  /// 
  /// This method walks the tree of external references, beginning with the master file, loading and decoding each referenced file in sequence. As each file is processed,
  /// any additional external references discovered within it are appended to the loader's reference list and are themselves subsequently loaded and decoded.
  /// 
  /// The decoding operation is performed sequentially (not concurrently) and is suitable for use cases that require strict ordering or simplified error handling.
  /// During the process, progress and status notifications are sent to the optional activity monitor, if present.
  /// 
  /// - Parameter transaction: The read-write (`SdaiTransactionRW`) transaction in which models and schema instances will be constructed and imported.
  /// 
  /// - Note: To perform decoding in parallel for improved performance, use `decodeConcurrently(transaction:)`.
  /// - SeeAlso: `decodeConcurrently(transaction:)`, `ExternalReference`, `ActivityMonitor`
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

  /// Decodes a hierarchy of STEP P21 exchange data files starting from the master file, recursively discovering and loading all external references into the repository, using concurrent tasks.
  ///
  /// This method traverses the tree of external references, beginning with the master file, and loads and decodes each referenced file concurrently using a Swift task group. As each file is processed, any additional external references discovered within it are appended to the loader's reference list and are subsequently loaded and decoded in parallel.
  ///
  /// Concurrent decoding can significantly improve performance when importing large or complex dependency graphs, as multiple files and their dependencies are processed simultaneously. This method is suitable for use cases where maximum throughput is desired and strict sequential ordering is not required.
  ///
  /// During processing, progress and status notifications are sent to the optional activity monitor, if present.
  ///
  /// - Parameter transaction: The read-write (`SdaiTransactionRW`) transaction in which models and schema instances will be constructed and imported.
  /// - Note: This operation is performed concurrently; for strict sequential decoding, use ``decode(transaction:)``.
  /// - SeeAlso: ``decode(transaction:)``, ``ExternalReference``, ``ActivityMonitor``
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

  /// Loads and decodes the specified external reference STEP P21 data stream, and discovers any child references.
  ///
  /// This asynchronous method attempts to load, decode, and register the external data specified by the given
  /// `externalReference`, using the provided transaction, activity monitor, reference resolver, and decoder.
  ///
  /// For each source property referenced by the external reference, the resolver determines whether it should be loaded,
  /// suspended, or marked as unknown. If loading is required, the method decodes the corresponding exchange structure,
  /// updates the external reference's status, and registers the exchange structure to avoid redundant decoding.
  /// Upon successful decoding, any child references discovered within the decoded instance are identified and returned.
  ///
  /// Progress and completion events are reported to the `monitor` if available. The method supports nonisolated invocation,
  /// enabling efficient concurrent or sequential import scenarios.
  ///
  /// - Parameters:
  ///   - externalReference: The external reference to load and decode, representing a STEP P21 data stream or resource.
  ///   - transaction: The read-write transaction in which decoded schema instances and models are constructed and imported.
  ///   - monitor: An optional activity monitor for reporting loading progress and completion events.
  ///   - resolver: The foreign reference resolver used to resolve document or file references.
  ///   - decoder: The decoder responsible for decoding the P21 exchange structure from the resolved data stream.
  ///
  /// - Returns: An array containing any child `ExternalReference`s discovered within the loaded data, or an empty array if none are found or if loading is not performed.
  ///
  /// - Note: This method is intended to be called internally by the loader during recursive or concurrent import operations.
  ///         It is typically not invoked directly by external clients.
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
			guard let child = ExternalReference(
        serial: await issueSerial(),
				upStream: parent,
        documentFile: documentFile,
        base: self.umbrellaFolder,
				resolver: resolver)
      else { continue }

			children.append(child)
		}
		
    monitor?.identified(children: children, originatedFrom: parent)

		return children
	}

}


