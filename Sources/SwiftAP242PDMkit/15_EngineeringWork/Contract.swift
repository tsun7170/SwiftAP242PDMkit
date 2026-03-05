//
//  Contract.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore




/// obtains all contracts contained in a schema instance (15.4.1.1)
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
///
public func contracts(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eCONTRACT.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eCONTRACT.self)
	return Set( instances.map{$0.pRef} )
}


/// obtains the contracts binding a given item (15.4.1.1,.3)
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
///
public func contracts(
	binding item: apPDM.sCONTRACT_ITEM?
) -> Set<apPDM.eAPPLIED_CONTRACT_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_CONTRACT_ASSIGNMENT.ITEMS) 
	return Set(usedin)
}


/// obtains items bound by a given contract (15.4.1.1,.3)
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
///
public func boundItems(
	by contract: apPDM.eCONTRACT.PRef?
) -> Set<apPDM.eAPPLIED_CONTRACT_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(T: contract, ROLE: \apPDM.eAPPLIED_CONTRACT_ASSIGNMENT.ASSIGNED_CONTRACT)
	return Set(usedin)
}

