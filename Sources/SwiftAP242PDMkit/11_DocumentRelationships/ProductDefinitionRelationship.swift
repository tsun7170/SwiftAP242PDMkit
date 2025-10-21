//
//  ProductDefinitionRelationship.swift
//  
//
//  Created by Yoshida on 2021/08/26.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains related product definitions
/// - Parameter productDefinition: relating product definition
/// - Returns: product definition relationships
/// 
/// # Reference
/// 11.2 Relationship between document representations;
/// 11.2.1 product_definition_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatedProductDefinitions(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(T: productDefinition, ROLE: \apPDM.ePRODUCT_DEFINITION_RELATIONSHIP.RELATING_PRODUCT_DEFINITION)
	return Set(usedin)
}

/// obtains relating product definitions
/// - Parameter productDefinition: related product definition
/// - Returns: product definition relationships
/// 
/// # Reference
/// 11.2 Relationship between document representations;
/// 11.2.1 product_definition_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatingProductDefinitions(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(T: productDefinition, ROLE: \apPDM.ePRODUCT_DEFINITION_RELATIONSHIP.RELATED_PRODUCT_DEFINITION)
	return Set(usedin)
}
