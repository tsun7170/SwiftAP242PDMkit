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


/// obtians the configuration effectivities associated with a given product configuration
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
public func usageEffectivities(in productConfiguration: ap242.eCONFIGURATION_DESIGN?) -> Set<ap242.eCONFIGURATION_EFFECTIVITY> {
	let usedin = SDAI.USEDIN(
		T: productConfiguration, 
		ROLE: \ap242.eCONFIGURATION_EFFECTIVITY.CONFIGURATION) 
	return Set(usedin)
}

//MARK: - Product Definition Effectivity


/// obtains the usage effectivities associated with a given sub-assembly
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
public func usageEffectivities(of subAssembly: ap242.ePRODUCT_DEFINITION_RELATIONSHIP?) -> Set<ap242.ePRODUCT_DEFINITION_EFFECTIVITY> {
	let usedin = SDAI.USEDIN(
		T: subAssembly, 
		ROLE: \ap242.ePRODUCT_DEFINITION_EFFECTIVITY.USAGE) 
	return Set(usedin)
}

//MARK: - General Validity Period Efectivity


/// obtains the general validity periods associated with a given product data item
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
public func generalValidityEfectivities(for item:ap242.sEFFECTIVITY_ITEM?) -> Set<ap242.eAPPLIED_EFFECTIVITY_ASSIGNMENT> {
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \ap242.eAPPLIED_EFFECTIVITY_ASSIGNMENT.ITEMS)
	return Set(usedin)
}

//MARK: - Effectivity Relationship


/// obtains related effectivity objects to a given effectivity object
/// - Parameter effectivity: effectivity object
/// - Returns: related effectivity objects
/// 
/// # Reference
/// 14.3.1.2 effectivity_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatedEffectivities(of effectivity: ap242.eEFFECTIVITY?) -> Set<ap242.eEFFECTIVITY_RELATIONSHIP> {
	let usedin = SDAI.USEDIN(T: effectivity, ROLE: \ap242.eEFFECTIVITY_RELATIONSHIP.RELATING_EFFECTIVITY) 
	return Set(usedin)
}

/// obtains relating effectivity objects to a given effectivity object
/// - Parameter effectivity: effectivity object
/// - Returns: relating effectivity objects
/// 
/// # Reference
/// 14.3.1.2 effectivity_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatingEffectivities(of effectivity: ap242.eEFFECTIVITY?) -> Set<ap242.eEFFECTIVITY_RELATIONSHIP> {
	let usedin = SDAI.USEDIN(T: effectivity, ROLE: \ap242.eEFFECTIVITY_RELATIONSHIP.RELATED_EFFECTIVITY) 
	return Set(usedin)
}

