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
	
	case multipleSuperCategories([ap242.ePRODUCT_CATEGORY_RELATIONSHIP])
	
	case multipleApplicationProtocols([ap242.eAPPLICATION_PROTOCOL_DEFINITION])
	
	case multiplePropertyRepresentations([ap242.ePROPERTY_DEFINITION_REPRESENTATION])
	
	case multipleProductDefinitionShapes([ap242.ePRODUCT_DEFINITION_SHAPE])
	
	case multipleDefinitionalShapes([ap242.ePROPERTY_DEFINITION_REPRESENTATION])
	
	case noGeometricRepresentationContext(ap242.eSHAPE_REPRESENTATION)
	
	case multipleContextDependentShapeRepresentations([ap242.eCONTEXT_DEPENDENT_SHAPE_REPRESENTATION])
	
	case multipleShapeDefinitionRepresentations([ap242.eSHAPE_DEFINITION_REPRESENTATION])
	
	case multipleMappedItems([ap242.eMAPPED_ITEM])
	
	case multiplePrecedingVersions([ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP])
	
	case multipleDocumentRepresentationTypes([ap242.eDOCUMENT_REPRESENTATION_TYPE])
	
	case multipleAssignedVersions([ap242.eAPPLIED_IDENTIFICATION_ASSIGNMENT])
	
	case multipleDocumentProductEquivalences([ap242.eDOCUMENT_PRODUCT_EQUIVALENCE])
	
	case multipleActionRequestStatus([ap242.eACTION_REQUEST_STATUS])
	
	case multipleDirectedActions([ap242.eDIRECTED_ACTION])

	case multipleActionStatus([ap242.eACTION_STATUS])

	case multiplePropertyDefinitions([ap242.ePROPERTY_DEFINITION])
}
