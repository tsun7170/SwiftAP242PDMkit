//
//  Effectivity.swift
//  
//
//  Created by Yoshida on 2021/08/27.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242

//MARK: - Configuration Effectivity


/// obtains the configuration effectivities associated with a given product configuration (14.2.1.1-3)
/// - Parameter productConfiguration: product configuration
/// - Returns: configuration effectivities
/// 
/// # Reference
/// 14.2.1 Configuration effectivity;
/// 14.2.1.1 effectivity;
/// 14.2.1.2 product_definition_effectivity;
/// 14.2.1.3 configuration_effectivity;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func usageEffectivities(
	in productConfiguration: apPDM.eCONFIGURATION_DESIGN.PRef?
) -> Set<apPDM.eCONFIGURATION_EFFECTIVITY.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productConfiguration, 
		ROLE: \apPDM.eCONFIGURATION_EFFECTIVITY.CONFIGURATION) 
	return Set(usedin)
}

//MARK: - Product Definition Effectivity


/// obtains the usage effectivities associated with a given sub-assembly (14.2.1.1-2)
/// - Parameter subAssembly: sub-assembly
/// - Returns: usage effectivities
/// 
/// # Reference
/// 14.2.1 Configuration effectivity;
/// 14.2.1.1 effectivity;
/// 14.2.1.2 product_definition_effectivity;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func usageEffectivities(
	of subAssembly: apPDM.ePRODUCT_DEFINITION_RELATIONSHIP.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION_EFFECTIVITY.PRef>
{
	let usedin = SDAI.USEDIN(
		T: subAssembly, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_EFFECTIVITY.USAGE) 
	return Set(usedin)
}

//MARK: - General Validity Period Efectivity


/// obtains the general validity periods associated with a given product data item  (14.2.1.3)
/// - Parameter item: product data item
/// - Returns: general validity periods
/// 
/// # Reference
/// 14.3 General Validity Period;
/// 14.3.1.3 applied_effectivity_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func generalValidityEfectivities(
	for item:apPDM.sEFFECTIVITY_ITEM?
) -> Set<apPDM.eAPPLIED_EFFECTIVITY_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_EFFECTIVITY_ASSIGNMENT.ITEMS)
	return Set(usedin)
}

//MARK: - Effectivity Relationship


/// obtains related effectivity objects to a given effectivity object (14.2.1.2)
/// - Parameter effectivity: effectivity object
/// - Returns: related effectivity objects
/// 
/// # Reference
/// 14.3.1.2 effectivity_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatedEffectivities(
	of effectivity: apPDM.eEFFECTIVITY.PRef?
) -> Set<apPDM.eEFFECTIVITY_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(T: effectivity, ROLE: \apPDM.eEFFECTIVITY_RELATIONSHIP.RELATING_EFFECTIVITY)
	return Set(usedin)
}

/// obtains relating effectivity objects to a given effectivity object (14.2.1.2)
/// - Parameter effectivity: effectivity object
/// - Returns: relating effectivity objects
/// 
/// # Reference
/// 14.3.1.2 effectivity_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatingEffectivities(
	of effectivity: apPDM.eEFFECTIVITY.PRef?
) -> Set<apPDM.eEFFECTIVITY_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(T: effectivity, ROLE: \apPDM.eEFFECTIVITY_RELATIONSHIP.RELATED_EFFECTIVITY)
	return Set(usedin)
}

