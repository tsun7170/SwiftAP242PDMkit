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

public class ExternalReferenceLoader: SDAI.Object {
	
	public var externalReferenceList: [ExternalReference] = []
	public var externalReferences: [String:ExternalReference] {
		let pairs = zip(externalReferenceList.map{$0.name}, externalReferenceList)
		return Dictionary(pairs) { (v1,v2) in return v1 }
	}
	private var exchangeStructures: [String:P21Decode.ExchangeStructure] = [:]
	
	public var sdaiModels: some Collection<SDAIPopulationSchema.SdaiModel> {
		let models = externalReferences.values.lazy.compactMap({$0.exchangeStructure?.sdaiModels}).joined()
		return models
	}
	
	private var decoder: P21Decode.Decoder
	private var monitor: ActivityMonitor?
	private var resolver: ForeignReferenceResolver

	public init?(
		repository: SDAISessionSchema.SdaiRepository,
		schemaList: P21Decode.SchemaList,
		masterFile: URL,
		monitor: ActivityMonitor?,
		foreignReferenceResolver: ForeignReferenceResolver = ForeignReferenceResolver()
	)
	{
		guard let decoder =
						P21Decode.Decoder(
							output: repository,
							schemaList: schemaList,
							monitor: monitor,
							foreignReferenceResolver: foreignReferenceResolver)
		else { return nil }
		self.decoder = decoder
		self.monitor = monitor
		self.resolver = foreignReferenceResolver

		let master = ExternalReference(asTopLevel: masterFile)
		self.externalReferenceList.append(master)
	}
	
	/// decode a tree of P21 exchange data files starting from the masterFile
	/// - Parameter transaction: RW transaction for SDAI-model construction
	/// 
	public func decode(
		transaction: SDAISessionSchema.SdaiTransactionRW
	)
	{
		var needToLoad = true
		while needToLoad {
			needToLoad = false
			
			for externalReference in externalReferenceList {
				if externalReference.status != .notLoadedYet { continue }
				if load(
					externalReference: externalReference,
					transaction: transaction)
				{
					needToLoad = true
				}
			}//for

		}//while
	}
	
	/// load a specified external reference p21 data stream
	/// - Parameters:
	///   - externalReference: external reference to a p21 data stream
	///   - transaction: RW transaction for decoding action
	/// - Returns: true when child external reference is found
	///
	public func load(
		externalReference: ExternalReference,
		transaction: SDAISessionSchema.SdaiTransactionRW
	) -> Bool
	{
		monitor?.startedLoading(externalReference: externalReference)
		defer{ monitor?.completedLoading(externalReference: externalReference) }
		
		for sourceProperty in externalReference.sourceProperties {
			switch resolver.disposition(of: sourceProperty) {
				case .load:
					if let exchange = exchangeStructures[externalReference.name] {
						externalReference.status = .loaded(exchange)
						return false
					}
					
					guard let p21stream = resolver.characterSteam(from: sourceProperty)
					else {
						externalReference.status = .inError(.referenceNotFound(sourceProperty))
						return false
					}
					guard
						let models = decoder.decode(input: p21stream, transaction: transaction),
						let exchange = decoder.exchangeStructure
					else {
						externalReference.status = .inError(.decoderError(decoder.error))
						return false
					}

					guard let schemaInstance = transaction.createSchemaInstance(
						repository: decoder.repository,
						name: externalReference.name,
						schema: apPDM.schemaDefinition)
					else {
						externalReference.status = .inError(.sdaiError(transaction.owningSession!.errors))
						return false
					}

					for model in models {
						let _ = transaction.addSdaiModel(
							instance: schemaInstance, model: model)
					}

					exchangeStructures[externalReference.name] = exchange
					externalReference.status = .loaded(exchange)

					let children = identifyExternalReferences(
						parent: externalReference,
						parentInstance: schemaInstance)

					return !children.isEmpty

				case .suspendLoading:
					externalReference.status = .loadPending
					return false
					
				case .referenceUnknown:
					continue
			}
		}
		externalReference.status = .foreignReference
		return false
	}
	
	private func identifyExternalReferences(
		parent: ExternalReference,
		parentInstance: SDAIPopulationSchema.SchemaInstance
	) -> [ExternalReference]
	{
		var children: [ExternalReference] = []

		for documentFile in documentFiles(in: parentInstance) {
			let child = ExternalReference(
				serial: externalReferenceList.count,
				upStream: parent,
				documentFile: documentFile,
				resolver: resolver)

			externalReferenceList.append(child)
			children.append(child)
		}
		
		monitor?.identified(externalReferences: children, originatedFrom: parent)

		return children
	}

}


