//
//  ExternalReference.swift
//  
//
//  Created by Yoshida on 2021/10/25.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


extension ExternalReferenceLoader {

	//MARK: - ExternalReference
  /// A representation of an external reference to a document and its associated product definitions,
  /// enabling structured navigation and access to nested external resources in a reference chain.
  /// 
  /// `ExternalReference` is typically used when loading or managing external STEP or PDM documents,
  /// enabling the association of source properties, hierarchical relationships, and loaded exchange structures.
  /// 
  /// Instances track their origin, associated document file, referencing parent (if any), and the
  /// exchange structure and loaded SDAI models when resolved. They also provide access to linkages between
  /// master and detail shape definitions across external references.
  /// 
  /// - Properties:
  ///   - documentFile: The referenced eDOCUMENT_FILE, if resolved.
  ///   - sourceProperties: An array of `DocumentSourceProperty` instances describing the reference sources.
  ///   - level: The depth in the external reference hierarchy.
  ///   - serial: A unique serial number in the loading context.
  ///   - upStream: The parent or upstream `ExternalReference` in the chain, if any.
  ///   - status: The current loading status of the reference.
  ///   - name: Unique, human-readable name for the reference, often based on serial and filename.
  ///   - exchangeStructure: The loaded `P21Decode.ExchangeStructure` if resolved, otherwise nil.
  ///   - sdaiModels: The list of associated `SDAIPopulationSchema.SdaiModel` instances if loaded.
  ///   - externalShapeDefinitionLinkages: The set of master-detail shape definition linkages found
  ///     between this document and external references.
  ///
  /// - Usage:
  ///   - Use `ExternalReference` to encapsulate a document reference, manage hierarchical relationships
  ///     as nested references are loaded, and resolve associated product/shape definitions.
  ///   - Supports chaining and recursive lookup via the `upStream` property and `level`.
  ///   - Integrates with external reference loading, status tracking, and resolved SDAI model access.
  ///
  /// - Thread Safety:
  ///   - Conforms to `Sendable`. Loading status is accessible as a `nonisolated(unsafe)` property.
  ///
	public final class ExternalReference: SDAI.Object, Sendable
  {
		public let documentFile: apPDM.eDOCUMENT_FILE.PRef?
		public let sourceProperties: [DocumentSourceProperty]
		public let level: Int
		public let serial: Int
		public let upStream: ExternalReference?

    nonisolated(unsafe)
		public internal(set) var status: LoadingStatus = .notLoadedYet

		public let name: String

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
		
		public init(asTopLevel url: URL, serial: Int) {
			self.sourceProperties = [DocumentSourceProperty(url: url)]
      self.level = 0
      self.serial = serial
			self.documentFile = nil
			self.upStream = nil
      self.name = "\(self.serial).\(self.sourceProperties[0].fileName)"
		}
		
		public init(
			serial: Int,
			upStream: ExternalReference,
			documentFile: apPDM.eDOCUMENT_FILE.PRef,
			resolver: ForeignReferenceResolver)
		{
			self.serial = serial
			self.documentFile = documentFile
			let docSources = fileLocations(of: documentFile)
			let parentSource = upStream.sourceProperties[0]
			self.sourceProperties = docSources
				.map{ resolver.fixupExternalReference($0, parent: parentSource) }
			self.upStream = upStream
			self.level = upStream.level + 1
      self.name = "\(self.serial).\(self.sourceProperties[0].fileName)"
		}
		
		public var externalShapeDefinitionLinkages: Set<ExternalShapeDefinitionLinkage> {
			var result: Set<ExternalShapeDefinitionLinkage> = []
			
      guard
        let detailExchange = self.exchangeStructure,
        let docFile = self.documentFile
			else { return result }

			let detailRepo = detailExchange.repository

			let detailDomain = detailRepo.contents.findSchemaInstance(named: self.name)

			let documentRefs = documentReferences(of: docFile)
			
			let documentApplications = applications(of: documentRefs).lazy
				.compactMap{$0.ITEMS}.joined()
			for productDef in documentApplications.compactMap({$0.super_ePRODUCT_DEFINITION})
			{
				guard let productDefinitionShape = try? shape(of: productDef) else { continue }

				let shapeReps = representations(of: productDefinitionShape)
				for masterShapeRep in shapeReps {
					if let detailShapeRep = _findDetailShapeRep(for: masterShapeRep, in: detailDomain) {
						result.insert(ExternalShapeDefinitionLinkage(
														master: masterShapeRep, 
														detail: detailShapeRep))
					}
				}//for
			}//for

			let shapeApplications = definitionalShapeApplications(of: documentRefs)
			for masterShapeRep in shapeApplications.lazy
				.compactMap({ try? shapeDefinition(
					of: $0.USED_REPRESENTATION?.sub_eSHAPE_REPRESENTATION?.pRef) })
			{
				if let detailShapeRep = _findDetailShapeRep(for: masterShapeRep, in: detailDomain) {
					result.insert(ExternalShapeDefinitionLinkage(
													master: masterShapeRep, 
													detail: detailShapeRep))
				}
			}//for

			return result		
		}
		
		private func _findDetailShapeRep(
			for masterShapeRep: apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef,
			in detailDomain: SDAIPopulationSchema.SchemaInstance?
		) -> apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef?
		{
			guard let masterProduct = masterShapeRep.DEFINITION?	// product_definition_shape
				.DEFINITION?.super_ePRODUCT_DEFINITION			// product_definition
				.FORMATION?.OF_PRODUCT 											// product
			else { return nil }
			
			for detailShapeRep in shapeDefinitionRepresentations(in: detailDomain) {
				if detailShapeRep.USED_REPRESENTATION?.NAME != masterShapeRep.USED_REPRESENTATION?.NAME { continue }

				if SDAI.IS_FALSE(detailShapeRep.USED_REPRESENTATION?.ID .==. masterShapeRep.USED_REPRESENTATION?.ID) { continue }

				guard let detailProduct = detailShapeRep.DEFINITION?
								.DEFINITION?.super_ePRODUCT_DEFINITION
					.FORMATION?.OF_PRODUCT
				else { continue }
				
				if detailProduct.NAME != masterProduct.NAME { continue }
				if detailProduct.ID != masterProduct.ID { continue }
				
				return detailShapeRep
			}//for
			return nil
		}
		
	}//class
}

extension ExternalReferenceLoader {
	//MARK: - LoadingStatus
	public enum LoadingStatus: Equatable {
		case notLoadedYet
		case loadPending
		case loaded(P21Decode.ExchangeStructure)
		case foreignReference
		case inError(LoadingError)
	}

	//MARK: - LoadingError
	public enum LoadingError: Equatable {
		case referenceNotFound(DocumentSourceProperty)
		case decoderError(P21Decode.Decoder.Error?)
		case sdaiError(SDAISessionSchema.LIST<SDAISessionSchema.ErrorEvent>)
	}
	
}

extension ExternalReferenceLoader.ExternalReference {
	//MARK: - ExternalShapeDefinitionLinkage
	public struct ExternalShapeDefinitionLinkage: Hashable {
		public var master: apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef
		public var detail: apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef
	}
}
