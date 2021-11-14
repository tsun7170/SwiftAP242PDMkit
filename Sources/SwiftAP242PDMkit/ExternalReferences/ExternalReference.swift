//
//  File.swift
//  
//
//  Created by Yoshida on 2021/10/25.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


extension ExternalReferenceLoader {
	public class ExternalReference: SDAI.Object {
		public var documentFile: ap242.eDOCUMENT_FILE? = nil
		public var sourceProperties: [DocumentSourceProperty]
		public var level: Int
		public var upStream: ExternalReference? = nil
		public var status: LoadingStatus = .notLoadedYet
		
		public private(set) lazy var name: String = {
			self.sourceProperties[0].fileName	
		}()
		
		public var exchangeStructure: P21Decode.ExchangeStructure? {
			switch self.status {
				case .loaded(let exchange):
					return exchange
				default:
					return nil
			}
		}
		
		public var sdaiModels: [SDAIPopulationSchema.SdaiModel] {
			guard let exchange = self.exchangeStructure else { return [] }
			return Array(exchange.sdaiModels)
		}
		
		public init(asTopLevel url: URL) {
			self.sourceProperties = [DocumentSourceProperty(url: url)]
			level = 0
		}
		
		public init(upStream: ExternalReference, documentFile: ap242.eDOCUMENT_FILE, resolver: ForeignReferenceResolver) {
			self.documentFile = documentFile
			let docSources = fileLocations(of: documentFile)
			let parentSource = upStream.sourceProperties[0]
			self.sourceProperties = docSources
				.map{ resolver.fixupExternalReference($0, parent: parentSource) }
			self.upStream = upStream
			self.level = upStream.level + 1
		}
		
		public lazy var externalShapeDefinitionLinkages: Set<ExternalShapeDefinitionLinkage> = {
			var result: Set<ExternalShapeDefinitionLinkage> = []
			
			guard let master = self.upStream,
						let masterExchange = master.exchangeStructure,
						let masterRepo = masterExchange.repository,
						let detailExchange = self.exchangeStructure,
						let detailRepo = detailExchange.repository,
						let docFile = self.documentFile
			else { return result }
			
			let masterDomain = masterRepo.createSchemaInstance(
				name: master.name + "ALL_MODELS", 
				schema: ap242.schemaDefinition )
			masterDomain.add(models: masterExchange.sdaiModels)
			masterDomain.mode = .readOnly
			defer { masterRepo.deleteSchemaInstance(instance: masterDomain) }
			
			let detailDomain = detailRepo.createSchemaInstance(
				name: self.name + "ALL_MODELS", 
				schema: ap242.schemaDefinition )
			detailDomain.add(models: detailExchange.sdaiModels)
			detailDomain.mode = .readOnly
			defer { detailRepo.deleteSchemaInstance(instance: detailDomain) }
			
			let documentRefs = documentReferences(of: docFile)
			
			let documentApplications = applications(of: documentRefs)
			for productDef in documentApplications.lazy.map({$0.ITEMS}).joined()
				.compactMap({$0.super_ePRODUCT_DEFINITION}) {
				guard let productDefinitionShape = try? shape(of: productDef) else { continue }
				let shapeReps = representations(of: productDefinitionShape)
				for masterShapeRep in shapeReps {
					if let detailShapeRep = _findDetailShapeRep(for: masterShapeRep, in: detailDomain) {
						result.insert(ExternalShapeDefinitionLinkage(
														master: masterShapeRep, 
														detail: detailShapeRep))
					}
				}
			}
			
			let shapeApplications = definitionalShapeApplications(of: documentRefs)
			for masterShapeRep in shapeApplications.lazy
				.compactMap({ try? shapeDefinition(of: $0.USED_REPRESENTATION.sub_eSHAPE_REPRESENTATION) }) {
				if let detailShapeRep = _findDetailShapeRep(for: masterShapeRep, in: detailDomain) {
					result.insert(ExternalShapeDefinitionLinkage(
													master: masterShapeRep, 
													detail: detailShapeRep))
				}
			}
			
			return result		
		}()
		
		private func _findDetailShapeRep(for masterShapeRep: ap242.eSHAPE_DEFINITION_REPRESENTATION, in detailDomain: SDAIPopulationSchema.SchemaInstance) -> ap242.eSHAPE_DEFINITION_REPRESENTATION? {
			guard let masterProduct = masterShapeRep.DEFINITION	// product_definition_shape
							.DEFINITION.super_ePRODUCT_DEFINITION?			// product_definition
							.FORMATION.OF_PRODUCT 											// product
			else { return nil }
			
			for detailShapeRep in shapeDefinitionRepresentations(in: detailDomain) {
				if detailShapeRep.USED_REPRESENTATION.NAME != masterShapeRep.USED_REPRESENTATION.NAME { continue }
				
				if SDAI.IS_FALSE(detailShapeRep.USED_REPRESENTATION.ID .==. masterShapeRep.USED_REPRESENTATION.ID) { continue }
				
				guard let detailProduct = detailShapeRep.DEFINITION
								.DEFINITION.super_ePRODUCT_DEFINITION?
								.FORMATION.OF_PRODUCT
				else { continue }
				
				if detailProduct.NAME != masterProduct.NAME { continue }
				if detailProduct.ID != masterProduct.ID { continue }
				
				return detailShapeRep
			}
			return nil
		}
		
	}
}

extension ExternalReferenceLoader {
	public enum LoadingStatus: Equatable {
		case notLoadedYet
		case loadPending
		case loaded(P21Decode.ExchangeStructure)
		case foreignReference
		case inError(LoadingError)
	}
	
	public enum LoadingError: Equatable {
		case referenceNotFound(DocumentSourceProperty)
		case decoderError(P21Decode.Decoder.Error?)
	}
	
}

extension ExternalReferenceLoader.ExternalReference {
	public struct ExternalShapeDefinitionLinkage: Hashable {
		public var master: ap242.eSHAPE_DEFINITION_REPRESENTATION
		public var detail: ap242.eSHAPE_DEFINITION_REPRESENTATION
	}
}
