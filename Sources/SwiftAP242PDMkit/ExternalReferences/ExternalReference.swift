//
//  ExternalReference.swift
//  
//
//  Created by Yoshida on 2021/10/25.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore



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
    /// The resolved STEP AP242 PDM document file entity referenced by this external reference, if available.
    ///
    /// - Discussion:
    ///   `documentFile` holds a reference to the `eDOCUMENT_FILE` persistent entity associated with this external reference,
    ///   if the referenced document has been resolved and loaded within the current context. The type is an optional persistent
    ///   reference (`PRef`) to the AP242 PDM document file entity (`apPDM.eDOCUMENT_FILE`), which serves as the source of product
    ///   and shape definitions relevant to the external reference hierarchy.
    ///
    ///   If the external reference has not yet been resolved or loaded, or if it does not correspond to a specific PDM document
    ///   entity, this property will be `nil`. Use this property to access metadata, product definitions, or related resources
    ///   from the referenced document within the STEP or PDM exchange structure.
    ///
    /// - Note:
    ///   This property is set during initialization of the external reference, either as `nil` (for top-level references)
    ///   or as the resolved document file entity for downstream/nested references.
    ///
    /// - SeeAlso:
    ///   - ``apPDM/eDOCUMENT_FILE``
    ///   - ``apPDM/eDOCUMENT_FILE/PRef``
    ///   - ``ExternalReferenceLoader/ExternalReference/init(serial:upStream:documentFile:resolver:)``
		public let documentFile: apPDM.eDOCUMENT_FILE.PRef?

    /// An array of `DocumentSourceProperty` instances describing the origins or source locations
    /// for the referenced external document.
    ///
    /// - Discussion:
    ///   `sourceProperties` encapsulates one or more properties related to how this external reference was sourced.
    ///   Each `DocumentSourceProperty` may include details such as the file URL, file name, and related metadata
    ///   about the document's origin or its referencing context.
    ///
    ///   For top-level references, this array typically contains a single entry reflecting the initial file reference.
    ///   For downstream or nested references, the array may be populated based on resolved file locations as determined
    ///   by foreign reference resolution processes, and may include any fixups applied by a `ForeignReferenceResolver`.
    ///
    ///   This property enables traceability of the document's origin and supports workflows that require access to
    ///   file-level or source-level metadata throughout the external reference handling lifecycle.
    ///
    /// - SeeAlso:
    ///   - ``DocumentSourceProperty``
    ///   - ``ForeignReferenceResolver``
		public let sourceProperties: [DocumentSourceProperty]

    /// The depth of this external reference in the reference hierarchy, starting from zero for the top-level reference.
    ///
    /// - Discussion:
    ///   `level` indicates how deeply nested the current `ExternalReference` is within the overall external reference chain.
    ///   A value of `0` corresponds to the root or primary reference (i.e., the initial document loaded).
    ///   For nested or downstream references, this value is incremented by one for each additional layer of referencing,
    ///   providing a convenient way to determine the structural position of a reference within the overall document graph.
    ///   This property is used to manage hierarchical traversal, display reference relationships, and organize external
    ///   references during loading or resolution workflows.
    ///
    /// - Example:
    ///   - A root external reference for a main document will have `level == 0`.
    ///   - A document referenced directly from the root will have `level == 1`.
    ///   - A document referenced from that secondary document will have `level == 2`, and so on.
		public let level: Int

    /// A unique serial number assigned to this external reference instance within the loading context.
    ///
    /// - Discussion:
    ///   The `serial` property provides a distinct identifier for each `ExternalReference` created by the loader.
    ///   It is incremented for every new reference, ensuring uniqueness among references in the same loading session.
    ///   This value is often used to distinguish between different references, assist with debugging, 
    ///   maintain deterministic ordering, or generate reference names (such as in the `name` property).
    ///
    ///   The serial number does not have a semantic meaning beyond its uniqueness in the context of reference loading,
    ///   but it aids in organizing and tracking the structure of external references as they are created and managed.
    ///
    /// - Note:
    ///   Typically, top-level (root) references receive a `serial` value of `0`, with subsequent nested or downstream
    ///   references assigned incrementing serial values as they are discovered and constructed.
    ///
    /// - SeeAlso:
    ///   - ``ExternalReferenceLoader/ExternalReference/name``
    ///   - ``ExternalReferenceLoader/ExternalReference/level``
		public let serial: Int

    /// The parent (upstream) `ExternalReference` in the external reference chain, if any.
    ///
    /// - Discussion:
    ///   `upStream` points to the immediate parent `ExternalReference` from which this reference was derived,
    ///   representing the hierarchical relationship in a chain of nested or cascaded external references.
    ///   For top-level references (i.e., those created for the root or initial document), this property is `nil`.
    ///   For nested or downstream references, `upStream` provides access to the reference that led to the creation
    ///   of the current instance, thus enabling traversal and inspection of the reference hierarchy.
    ///
    ///   Use this property to navigate backward through the reference structure, access context from parent documents,
    ///   or to recursively process or display external references in their hierarchical context.
    ///
    /// - Note:
    ///   - The reference chain formed via `upStream` supports recursive algorithms, tracing of origin, and context-aware
    ///     loading or resolution procedures.
    ///   - This property is set during initialization and does not change for the lifetime of the `ExternalReference`.
		public let upStream: ExternalReference?

    /// The current loading status of the external reference.
    ///
    /// - Discussion:
    ///   The `status` property tracks the progress or result of loading the external reference,
    ///   representing whether the referenced document has not yet started loading, is in progress,
    ///   has completed loading, is recognized as a foreign (unresolvable) reference, or failed
    ///   due to an error. This enables robust state management and error handling when navigating
    ///   external documents in the reference hierarchy.
    ///
    ///   The property is accessible in a nonisolated (unsafe) manner, supporting use in
    ///   concurrent or multi-threaded contexts where thread safety is managed externally.
    ///
    /// - Possible Values:
    ///   - `.notLoadedYet`: The reference has been created but loading has not started.
    ///   - `.loadPending`: The reference is scheduled for loading or is currently loading.
    ///   - `.loaded(P21Decode.ExchangeStructure)`: The document was loaded successfully,
    ///       providing the exchange structure.
    ///   - `.foreignReference`: The reference is to a foreign or unsupported document
    ///       and will not be loaded.
    ///   - `.inError(LoadingError)`: An error occurred during loading, with details in the associated value.
    ///
    /// - Note:
    ///   This property is set and updated by the `ExternalReferenceLoader` as the loading process progresses.
    ///   It is intended for status monitoring and should not be directly modified by external clients.
    ///
    /// - SeeAlso:
    ///   - ``ExternalReferenceLoader/LoadingStatus``
    ///   - ``ExternalReferenceLoader/ExternalReference/exchangeStructure``
    nonisolated(unsafe)
		public internal(set) var status: LoadingStatus = .notLoadedYet

    /// A unique, human-readable identifier for this external reference instance.
    ///
    /// - Discussion:
    ///   The `name` property combines the `serial` number and the primary source file name to generate
    ///   a concise, descriptive label for the external reference. This makes it easy to distinguish and
    ///   refer to different references within the same loading context, especially when displaying
    ///   reference lists, organizing nested references, or logging activities.
    ///
    ///   The format is typically `"serial.fileName"`, where `serial` is the unique serial number assigned
    ///   to this reference, and `fileName` is extracted from the first element of the `sourceProperties` array.
    ///   This convention ensures uniqueness as well as contextual relevance, as the name always reflects both
    ///   the instance order and the referenced file.
    ///
    /// - Note:
    ///   - This property is set during initialization and remains constant for the lifetime of the reference.
    ///   - For debugging, presentation, or tracking purposes, use `name` to identify and differentiate references.
    ///
    /// - Example:
    ///   If `serial` is `2` and the file name is `"assembly.stp"`, `name` will be `"2.assembly.stp"`.
		public let name: String

    /// The loaded STEP exchange structure associated with this external reference, if available.
    ///
    /// - Discussion:
    ///   The `exchangeStructure` property provides access to the `P21Decode.ExchangeStructure` for this external reference,
    ///   representing the decoded content of the referenced STEP or PDM document. If the external reference has been
    ///   successfully loaded (i.e., its `status` is `.loaded`), this property will return the corresponding exchange
    ///   structure instance, enabling clients to inspect models, entities, and data within the referenced document.
    ///
    ///   If the reference has not yet been loaded, is pending, encountered an error, or refers to a foreign document,
    ///   this property will return `nil`. Use this property to determine whether document content is available for
    ///   navigation or further processing.
    ///
    /// - Note:
    ///   - The value of `exchangeStructure` is derived from the `status` property and is read-only.
    ///   - Accessing this property does not trigger loading; it is purely a reflection of the current status.
    ///
    /// - SeeAlso:
    ///   - ``ExternalReferenceLoader/ExternalReference/status``
    ///   - ``P21Decode/ExchangeStructure``
		public var exchangeStructure: P21Decode.ExchangeStructure? {
			switch self.status {
				case .loaded(let exchange):
					return exchange
				default:
					return nil
			}
		}
		
    /// The list of loaded SDAI models associated with this external reference, if available.
    ///
    /// - Discussion:
    ///   The `sdaiModels` property returns an array of `SDAIPopulationSchema.SdaiModel` instances that have been
    ///   loaded as part of the referenced document's exchange structure. These models represent the parsed and
    ///   decoded content of the external STEP or PDM document, providing access to all SDAI entities and relationships
    ///   defined within the scope of the referenced file.
    ///
    ///   If the external reference has not yet been loaded, or if the loading process failed or was not applicable,
    ///   this array will be empty. Accessing this property does not trigger loading; it reflects only the
    ///   currently loaded state as determined by the `exchangeStructure` property.
    ///
    /// - Note:
    ///   - The contents of this array are determined by the `exchangeStructure` property, which must be non-nil.
    ///   - Use this property to enumerate or inspect all SDAI models available within the scope of the external reference.
    ///   - For top-level and downstream references alike, this property enables traversal of the loaded schema data
    ///     as relevant to each external document.
    ///
    /// - SeeAlso:
    ///   - ``ExternalReferenceLoader/ExternalReference/exchangeStructure``
    ///   - ``SDAIPopulationSchema/SdaiModel``
		public var sdaiModels: [SDAIPopulationSchema.SdaiModel] {
			guard let exchange = self.exchangeStructure else { return [] }
			return Array(exchange.sdaiModels)
		}
		
    /// Initializes a new top-level `ExternalReference` representing the root of the external reference hierarchy.
    ///
    /// Use this initializer when creating an `ExternalReference` for the initial (primary) document,
    /// such as when starting the loading process for a root STEP or PDM file. This instance will have no upstream
    /// parent and will be at level 0 in the reference hierarchy.
    ///
    /// - Parameters:
    ///   - url: The URL of the top-level external document to be referenced.
    ///   - serial: A unique serial number for this reference instance within the loading context.
    ///
    /// The resulting `ExternalReference` will be initialized with its source property based on the given URL,
    /// level set to zero, and no upstream reference.
    ///
    /// - Note: This initializer is intended for use when initially loading or managing the main external document,
    /// prior to resolving any nested or downstream references.
		public init?(
      asTopLevel url: URL,
      serial: Int,
      base: URL)
    {
      let docSource = DocumentSourceProperty(url: url, base: base)
      guard docSource.targetURL != nil
      else { return nil }

      self.sourceProperties = [docSource]
      self.level = 0
      self.serial = serial
			self.documentFile = nil
			self.upStream = nil
      self.name = "\(self.serial).\(docSource.fileName)"
		}
		
    /// Initializes a new downstream `ExternalReference` representing a nested or child reference within the external reference hierarchy.
    ///
    /// Use this initializer when creating an `ExternalReference` for a document that is referenced from another document (the upstream or parent).
    /// This instance will have its upstream reference set, its level incremented relative to its parent, and its source properties derived
    /// from the referenced document file with any necessary fixups applied by the supplied resolver.
    ///
    /// - Parameters:
    ///   - serial: A unique serial number for this reference instance within the loading context.
    ///   - upStream: The parent (upstream) `ExternalReference` in the hierarchical reference chain.
    ///   - documentFile: The resolved `eDOCUMENT_FILE` entity representing the referenced external document.
    ///   - resolver: The `ForeignReferenceResolver` responsible for resolving and fixing up external reference properties as needed.
    ///
    /// The resulting `ExternalReference` will be initialized with source properties based on the referenced file (and resolver),
    /// its level set to the upstream's level plus one, and its name constructed from its serial and primary source file name.
    ///
    /// - Note: This initializer is intended for use when loading or managing nested external document references discovered during
    ///         traversal of a parent document's external reference relationships.
		public init?(
			serial: Int,
			upStream: ExternalReference,
			documentFile: apPDM.eDOCUMENT_FILE.PRef?,
      base: URL,
			resolver: ForeignReferenceResolver)
		{
      guard let parentSource = upStream.sourceProperties.first
      else { return nil }

      let docSources = fileLocations(
        of: documentFile,
        base: base,
        parent: parentSource,
        resolver: resolver)
      guard let fileName = docSources.first?.fileName
      else { return nil }

      self.serial = serial
      self.documentFile = documentFile

			self.sourceProperties = docSources
			self.upStream = upStream
			self.level = upStream.level + 1
      self.name = "\(self.serial).\(fileName)"
		}
		
    /// The set of shape definition linkages connecting "master" and "detail" shape representations across external references.
    ///
    /// - Discussion:
    ///   The `externalShapeDefinitionLinkages` property analyzes the loaded exchange structure and document metadata for this external reference,
    ///   discovering correspondences between shape definition representations in the master (referencing) document and their counterparts in the
    ///   detail (referenced) document. Each linkage represents a relationship between a shape defined in the master document and a matching shape
    ///   in the detail document, enabling navigation and traceability between product or component definitions that span multiple STEP or PDM files.
    ///
    ///   The computation examines product definitions and shape representations, matching them based on product identity, representation name,
    ///   and representation ID to ensure structural and semantic equivalence. It processes both direct product definitions and shape applications,
    ///   covering typical referencing scenarios encountered in modular assemblies or federated document structures.
    ///
    /// - Returns:
    ///   A set of `ExternalShapeDefinitionLinkage` instances, each linking a master shape definition representation in the referencing document
    ///   to its corresponding detail shape definition representation in the referenced document. The set may be empty if no such linkages are found,
    ///   if the document is not loaded, or if the reference does not correspond to a resolved document file.
    ///
    /// - Note:
    ///   - This property is computed dynamically based on the current exchange structure and associated entities.
    ///   - Use this property to support cross-document navigation, model federation, or validation of shape correspondences between documents.
    ///   - Requires that the external reference is resolved and loaded; otherwise, the set will be empty.
    ///
    /// - SeeAlso:
    ///   - ``ExternalReferenceLoader/ExternalReference/ExternalShapeDefinitionLinkage``
    ///   - ``ExternalReferenceLoader/ExternalReference/exchangeStructure``
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
			for productDef in documentApplications.compactMap({$0.underlying_ePRODUCT_DEFINITION})
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
				.DEFINITION?.underlying_ePRODUCT_DEFINITION?			// product_definition
				.FORMATION?.OF_PRODUCT 											// product
			else { return nil }
			
			for detailShapeRep in shapeDefinitionRepresentations(in: detailDomain) {
				if detailShapeRep.USED_REPRESENTATION?.NAME != masterShapeRep.USED_REPRESENTATION?.NAME { continue }

				if SDAI.IS_FALSE(detailShapeRep.USED_REPRESENTATION?.ID .==. masterShapeRep.USED_REPRESENTATION?.ID) { continue }

				guard let detailProduct = detailShapeRep.DEFINITION?
								.DEFINITION?.underlying_ePRODUCT_DEFINITION?
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
  /// Represents the current loading state of an `ExternalReference`.
  ///
  /// `LoadingStatus` is used to track and communicate the progress or outcome of attempting to load a referenced document,
  /// such as a STEP or PDM file, within the `ExternalReferenceLoader` context. Each status corresponds to a distinct
  /// phase or result in the external reference handling lifecycle:
  ///
  /// - `notLoadedYet`: The external reference has been created, but loading has not yet started. This is the initial state.
  /// - `loadPending`: Loading of the external reference is scheduled or in progress, but not yet complete.
  /// - `loaded(P21Decode.ExchangeStructure)`: The referenced external document has been successfully loaded and decoded,
  ///      with the resulting exchange structure provided.
  /// - `foreignReference`: The reference points to a foreign (possibly unresolvable) resource that will not be loaded
  ///      as a standard document in this context.
  /// - `inError(LoadingError)`: An error has occurred during loading, with associated details in a `LoadingError` value.
  ///
  /// Use `LoadingStatus` to monitor and manage state transitions for external document references, enabling robust control
  /// flow, error handling, and progress reporting during document loading operations.
	public enum LoadingStatus: Equatable {
		case notLoadedYet
		case loadPending
		case loaded(P21Decode.ExchangeStructure)
		case foreignReference
		case inError(LoadingError)
	}

	//MARK: - LoadingError
  /// Represents possible errors that can occur during the loading of an external reference.
  /// 
  /// `LoadingError` provides detailed error cases for failures encountered while resolving,
  /// decoding, or loading a referenced document, enabling robust error handling and reporting
  /// within the context of external reference management.
  /// 
  /// - Cases:
  ///     - `referenceNotFound(DocumentSourceProperty)`: Indicates that an external reference
  ///        could not be found or resolved at the given source property.
  ///     - `decoderError(P21Decode.Decoder.Error?)`: Indicates that a decoding error occurred
  ///        when attempting to process the referenced document, optionally providing underlying
  ///        decoder error details.
  ///     - `sdaiError(SDAISessionSchema.LIST<SDAISessionSchema.ErrorEvent>)`: Indicates that one
  ///        or more SDAI errors occurred while loading or processing the external reference,
  ///        with details provided as a list of error events.
  /// 
  /// Use `LoadingError` to diagnose and respond to specific failure modes in the loading pipeline
  /// for external references to STEP or PDM documents.
	public enum LoadingError: Equatable {
		case referenceNotFound(DocumentSourceProperty)
		case decoderError(P21Decode.Decoder.Error?)
		case sdaiError(SDAISessionSchema.LIST<SDAISessionSchema.ErrorEvent>)
	}
	
}

extension ExternalReferenceLoader.ExternalReference {
	//MARK: - ExternalShapeDefinitionLinkage
  /// Represents a linkage between a "master" and "detail" shape definition across external references.
  ///
  /// `ExternalShapeDefinitionLinkage` is typically used to associate a shape definition representation in a referencing
  /// (master) document with its corresponding shape definition representation in a referenced (detail) document. This
  /// facilitates cross-document navigation and traceability between related product definition shapes, such as those
  /// encountered when working with nested or hierarchical STEP or PDM files.
  ///
  /// - Properties:
  ///   - master: The shape definition representation in the referencing (master) document.
  ///   - detail: The corresponding shape definition representation in the referenced (detail) document.
  ///
  /// Use `ExternalShapeDefinitionLinkage` to capture, query, or process shape definition relationships that span
  /// multiple externally referenced documents, supporting workflows such as model federation, modular assembly,
  /// or cross-document validation.
  ///
  /// Conforms to `Hashable` to enable use in sets and as dictionary keys.
	public struct ExternalShapeDefinitionLinkage: Hashable {
		public var master: apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef
		public var detail: apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef
	}
}
