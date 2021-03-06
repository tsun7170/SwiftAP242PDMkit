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
	case duplicatedCatrgoryName(ap242.ePRODUCT_CATEGORY, ap242.ePRODUCT_CATEGORY)
	
	case multipleSuperCategories(Set<ap242.ePRODUCT_CATEGORY_RELATIONSHIP>)
	
	case multipleApplicationProtocols(Set<ap242.eAPPLICATION_PROTOCOL_DEFINITION>)
	
	case multiplePropertyRepresentations(Set<ap242.ePROPERTY_DEFINITION_REPRESENTATION>)
	
	case multipleProductDefinitionShapes(Set<ap242.ePRODUCT_DEFINITION_SHAPE>)
	
	case multipleDefinitionalShapes(Set<ap242.ePROPERTY_DEFINITION_REPRESENTATION>)
	
	case noGeometricRepresentationContext(ap242.eSHAPE_REPRESENTATION)
	
	case multipleContextDependentShapeRepresentations(Set<ap242.eCONTEXT_DEPENDENT_SHAPE_REPRESENTATION>)
	
	case multipleShapeDefinitionRepresentations(Set<ap242.eSHAPE_DEFINITION_REPRESENTATION>)
	
	case multipleMappedItems(Set<ap242.eMAPPED_ITEM>)
	
	case multiplePrecedingVersions(Set<ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP>)
	
	case multipleDocumentRepresentationTypes(Set<ap242.eDOCUMENT_REPRESENTATION_TYPE>)
	
	case multipleAssignedVersions(Set<ap242.eAPPLIED_IDENTIFICATION_ASSIGNMENT>)
	
	case multipleDocumentProductEquivalences(Set<ap242.eDOCUMENT_PRODUCT_EQUIVALENCE>)
	
	case multipleActionRequestStatus(Set<ap242.eACTION_REQUEST_STATUS>)
	
	case multipleDirectedActions(Set<ap242.eDIRECTED_ACTION>)

	case multipleActionStatus(Set<ap242.eACTION_STATUS>)

	case multiplePropertyDefinitions(Set<ap242.ePROPERTY_DEFINITION>)
}
