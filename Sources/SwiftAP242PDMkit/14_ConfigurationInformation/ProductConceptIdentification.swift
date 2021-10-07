//
//  ProductConceptIdentification.swift
//  
//
//  Created by Yoshida on 2021/08/27.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242

//MARK: - Configuration Identification


/// obtains all product concepts contained in a schema instance
/// - Parameter domain: schema instance
/// - Returns: all product concepts found
/// 
/// # Reference
/// 14.1 Configuration Identification;
/// 14.1.1 Product Concept Identification;
/// 14.1.1.1 product_concept;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func productConcepts(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.ePRODUCT_CONCEPT> {
	let instances = domain.entityExtent(type: ap242.ePRODUCT_CONCEPT.self)
	return Set(instances)
}

//MARK: - Product Concept Configuration Identification


/// obtains configurations for a given product concept
/// - Parameter productConcept: product concept
/// - Returns: product configurations
/// 
/// # Reference
/// 14.1.2 Product Concept Configuration Identification;
/// 14.1.2.1 configuration_item;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func productConfigurations(for productConcept: ap242.ePRODUCT_CONCEPT) -> Set<ap242.eCONFIGURATION_ITEM> {
	if let usedin = SDAI.USEDIN(
			T: productConcept, 
			ROLE: \ap242.eCONFIGURATION_ITEM.ITEM_CONCEPT) {
		return Set(usedin)
	}
	return []
}


/// obtains the designs for a given product configuration
/// - Parameter productConfiguration: product configuration
/// - Returns: configuration designs
/// 
/// # Reference
/// 14.1.2 Product Concept Configuration Identification;
/// 14.1.2.1 configuration_item;
/// 14.1.2.2 configuration_design;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func configurationDesigns(for productConfiguration: ap242.eCONFIGURATION_ITEM) -> Set<ap242.eCONFIGURATION_DESIGN> {
	if let usedin = SDAI.USEDIN(
			T: productConfiguration, 
			ROLE: \ap242.eCONFIGURATION_DESIGN.CONFIGURATION) {
		return Set(usedin)
	}
	return []
}


