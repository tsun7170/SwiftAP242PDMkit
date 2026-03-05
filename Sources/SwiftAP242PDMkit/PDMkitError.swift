//
//  PDMkitError.swift
//  
//
//  Created by Yoshida on 2021/08/30.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore


/// An enumeration representing errors that can occur within the PDMkit domain.
/// 
/// Each case describes a specific error scenario encountered when handling
/// Product Data Management (PDM) entities, typically related to the STEP AP242 schema.
/// 
/// - Note: Most cases provide context by including references to affected entities,
///         such as STEP object references or sets of references, to aid in debugging
///         and error tracing.
/// 
/// Cases:
///   - **duplicatedCategoryName**: Indicates that two product categories share the same name.
///   - **multipleSuperCategories**: Multiple super-category relationships found for a product category.
///   - **multipleApplicationProtocols**: More than one application protocol definition detected.
///   - **multiplePropertyRepresentations**: Multiple representations assigned to a single property definition.
///   - **multipleProductDefinitionShapes**: Multiple shapes found for a product definition.
///   - **multipleDefinitionalShapes**: Multiple definitional shapes assigned to a property definition representation.
///   - **noGeometricRepresentationContext**: No geometric representation context found for a shape representation.
///   - **multipleContextDependentShapeRepresentations**: More than one context-dependent shape representation found.
///   - **multipleShapeDefinitionRepresentations**: Multiple shape definition representations found.
///   - **multipleMappedItems**: Multiple mapped items associated where only one is expected.
///   - **multiplePrecedingVersions**: More than one preceding version found for a product definition formation relationship.
///   - **multipleDocumentRepresentationTypes**: Multiple document representation types found.
///   - **multipleAssignedVersions**: Multiple assigned identification assignments found.
///   - **multipleDocumentProductEquivalences**: Multiple document-product equivalences found.
///   - **multipleActionRequestStatus**: Multiple status objects found for an action request.
///   - **multipleDirectedActions**: Multiple directed actions found where only one is expected.
///   - **multipleActionStatus**: Multiple action status objects found.
///   - **multiplePropertyDefinitions**: Multiple property definitions found where only one is expected.
///
public enum PDMkitError: Error {
	case duplicatedCategoryName(apPDM.ePRODUCT_CATEGORY.PRef, apPDM.ePRODUCT_CATEGORY.PRef)

	case multipleSuperCategories(Set<apPDM.ePRODUCT_CATEGORY_RELATIONSHIP.PRef>)

	case multipleApplicationProtocols(Set<apPDM.eAPPLICATION_PROTOCOL_DEFINITION.PRef>)

	case multiplePropertyRepresentations(Set<apPDM.ePROPERTY_DEFINITION_REPRESENTATION.PRef>)

	case multipleProductDefinitionShapes(Set<apPDM.ePRODUCT_DEFINITION_SHAPE.PRef>)

	case multipleDefinitionalShapes(Set<apPDM.ePROPERTY_DEFINITION_REPRESENTATION.PRef>)

	case noGeometricRepresentationContext(apPDM.eSHAPE_REPRESENTATION.PRef)

	case multipleContextDependentShapeRepresentations(Set<apPDM.eCONTEXT_DEPENDENT_SHAPE_REPRESENTATION.PRef>)

	case multipleShapeDefinitionRepresentations(Set<apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef>)

	case multipleMappedItems(Set<apPDM.eMAPPED_ITEM.PRef>)

	case multiplePrecedingVersions(Set<apPDM.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.PRef>)

	case multipleDocumentRepresentationTypes(Set<apPDM.eDOCUMENT_REPRESENTATION_TYPE.PRef>)

	case multipleAssignedVersions(Set<apPDM.eAPPLIED_IDENTIFICATION_ASSIGNMENT.PRef>)

	case multipleDocumentProductEquivalences(Set<apPDM.eDOCUMENT_PRODUCT_EQUIVALENCE.PRef>)

	case multipleActionRequestStatus(Set<apPDM.eACTION_REQUEST_STATUS.PRef>)

	case multipleDirectedActions(Set<apPDM.eDIRECTED_ACTION.PRef>)

	case multipleActionStatus(Set<apPDM.eACTION_STATUS.PRef>)

	case multiplePropertyDefinitions(Set<apPDM.ePROPERTY_DEFINITION.PRef>)
}
