//
//  File.swift
//  
//
//  Created by Yoshida on 2021/10/19.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242

public class ExternalReferenceLoader: SDAI.Object {
	
	public var externalReferences: [String:ExternalReference] = [:]

	public var sdaiModels: AnySequence<SDAIPopulationSchema.SdaiModel> {
		let models = externalReferences.values.lazy.compactMap({$0.exchangeStructure?.sdaiModels}).joined()
		return AnySequence(models)
	}
	
	private var decoder: P21Decode.Decoder
	private var monitor: ActivityMonitor?
	private var resolver: ForeignReferenceResolver

	public init?(repository: SDAISessionSchema.SdaiRepository,
							schemaList: P21Decode.SchemaList,
							masterFile: URL,
							monitor: ActivityMonitor?,
							foreginReferenceResolver: ForeignReferenceResolver = ForeignReferenceResolver() 
	) {
		guard let decoder = P21Decode.Decoder(
						output: repository, 
						schemaList: schemaList,
						monitor: monitor,
						foreginReferenceResolver: foreginReferenceResolver) 
		else { return nil }
		self.decoder = decoder
		self.monitor = monitor
		self.resolver = foreginReferenceResolver

		let master = ExternalReference(asTopLevel: masterFile)
		self.externalReferences[master.name] = master
		
		super.init()
	}
	
	public func decode() {
		var needToLoad = true
		while needToLoad {
			needToLoad = false
			
			for externalReference in externalReferences.values {
				if externalReference.status != .notLoadedYet { continue }
				if load(externalReference: externalReference) {
					needToLoad = true					
				}
			}
			
		}
	}
	
	public func load(externalReference: ExternalReference) -> Bool {
		monitor?.startedLoading(externalReference: externalReference)
		defer{ monitor?.completedLoading(externalReference: externalReference) }
		
		for sourceProperty in externalReference.sourceProperties {
			switch resolver.dispositon(of: sourceProperty) {
				case .load:
					guard let stream = resolver.characterSteam(from: sourceProperty) else {
						externalReference.status = .inError(.referenceNotFound(sourceProperty))
						return false
					}
					guard let _ = decoder.decode(input: stream),
								let exchange = decoder.exchangeStructrure else {
						externalReference.status = .inError(.decoderError(decoder.error))
						return false
					}
					externalReference.status = .loaded(exchange)
					externalReference.sourceProperties = [sourceProperty]
					let children = identifyExternalReferences(parent: externalReference)
					for child in children {
						externalReferences[child.name] = child
					}
					return true
					
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
	
	private func identifyExternalReferences(parent: ExternalReference) -> [ExternalReference] {
		var result: [ExternalReference] = []
		guard let models = parent.exchangeStructure?.sdaiModels else { return result }
		
		let repository = decoder.repository
		let schemaInstance = repository.createSchemaInstance(
			name: parent.name + ".TEMP", 
			schema: ap242.schemaDefinition )
		schemaInstance.add(models: models)
		schemaInstance.mode = .readOnly
		
		for documentFile in documentFiles(in: schemaInstance) {
			let child = ExternalReference(upStream: parent, documentFile: documentFile, resolver: resolver)
			result.append(child)
		}
		
		repository.deleteSchemaInstance(instance: schemaInstance)
		monitor?.identified(externalReferences: result, originatedFrom: parent)
		return result
	}

}


