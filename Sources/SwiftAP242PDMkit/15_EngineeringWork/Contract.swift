//
//  Contract.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242



/// obtains all contracts contained in a schema instance
/// - Parameter domain: schema instance
/// - Returns: all contracts found
/// 
/// # Reference
/// 15.4 Contract Identification;
/// 15.4.1.1 contract;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func contracts(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.eCONTRACT> {
	let instances = domain.entityExtent(type: ap242.eCONTRACT.self)
	return Set(instances)
}


/// obtains the contracts binding a given item
/// - Parameter item: item
/// - Returns: contract bindings
/// 
/// # Reference
/// 15.4 Contract Identification;
/// 15.4.1.1 contract;
/// 15.4.1.3 applied_contract_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func contracts(binding item: ap242.sCONTRACT_ITEM?) -> Set<ap242.eAPPLIED_CONTRACT_ASSIGNMENT> {
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \ap242.eAPPLIED_CONTRACT_ASSIGNMENT.ITEMS) 
	return Set(usedin)
}

/// 15.4 Contract Identification;
/// 15.4.1.1 contract;
/// 15.4.1.3 applied_contract_assignment;

/// obtains items bound by a given contract
/// - Parameter contract: contract
/// - Returns: bound items
/// 
/// # Reference
/// 15.4 Contract Identification;
/// 15.4.1.1 contract;
/// 15.4.1.3 applied_contract_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func boundItems(by contract: ap242.eCONTRACT?) -> Set<ap242.eAPPLIED_CONTRACT_ASSIGNMENT> {
	let usedin = SDAI.USEDIN(T: contract, ROLE: \ap242.eAPPLIED_CONTRACT_ASSIGNMENT.ASSIGNED_CONTRACT) 
	return Set(usedin)
}

