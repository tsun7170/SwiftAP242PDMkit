//
//  PDMkitError.swift
//  
//
//  Created by Yoshida on 2021/08/30.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242

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
