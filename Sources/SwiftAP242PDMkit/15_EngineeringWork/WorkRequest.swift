//
//  WorkRequest.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains all work requests contained in a schema instance
/// - Parameter domain: schema instance
/// - Returns: all work requests found
/// 
/// # Reference
/// 15.1 Request for Work;
/// 15.1.1.1 versioned_action_request;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func workRequests(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.eVERSIONED_ACTION_REQUEST> {
	let instances = domain.entityExtent(type: ap242.eVERSIONED_ACTION_REQUEST.self)
	return Set(instances)
}


/// obtains all initial design work requests contained in a shcema instance
/// - Parameter domain: schema instance
/// - Returns: all initial desing work requests found
/// 
/// # Reference
/// 15.1 Request for Work;
/// 15.1.1.1 versioned_action_request;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func initialDesignWorkRequests(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.eVERSIONED_ACTION_REQUEST> {
	let allWorkRequests = workRequests(in: domain)
	let changeWorkRequests = designChangeWorkRequests(in: domain)
		.map{ $0.ASSIGNED_ACTION_REQUEST }
	let initialWorkRequests = allWorkRequests.subtracting(changeWorkRequests)
	return initialWorkRequests
}


/// obtains all design change work requests found in a schema instance
/// - Parameter domain: schema instance
/// - Returns: all design change work requests found
/// 
/// # Reference
/// 15.1 Request for Work;
/// 15.1.1.1 versioned_action_request;
/// 15.1.1.3 applied_action_request_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func designChangeWorkRequests(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.eAPPLIED_ACTION_REQUEST_ASSIGNMENT> {
	let instances = domain.entityExtent(type: ap242.eAPPLIED_ACTION_REQUEST_ASSIGNMENT.self)
	return Set(instances)
}


/// obtains the potential solutions associated with a given work request
/// - Parameter workRequest: work request
/// - Returns: potential solutions
/// obtains all design change work requests found in a schema instance
/// - Parameter domain: schema instance
/// - Returns: all design change work requests found
/// 
/// # Reference
/// 15.1 Request for Work;
/// 15.1.1.1 versioned_action_request;
/// 15.1.1.4 action_request_solution;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func potentialSolutions(for workRequest: ap242.eVERSIONED_ACTION_REQUEST) -> Set<ap242.eACTION_REQUEST_SOLUTION> {
	let usedin = SDAI.USEDIN(
		T: workRequest, 
		ROLE: \ap242.eACTION_REQUEST_SOLUTION.REQUEST)
	return Set(usedin)
}


/// obtains change items assigned to a given work request
/// - Parameter workRequest: work request
/// - Returns: assigned change items
/// 
/// # Reference
/// 15.1 Request for Work;
/// 15.1.1.1 versioned_action_request;
/// 15.1.1.3 applied_action_request_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func assignedChangeItems(to workRequest: ap242.eVERSIONED_ACTION_REQUEST) -> Set<ap242.eAPPLIED_ACTION_REQUEST_ASSIGNMENT> {
	let usedin = SDAI.USEDIN(
		T: workRequest, 
		ROLE: \ap242.eAPPLIED_ACTION_REQUEST_ASSIGNMENT.ASSIGNED_ACTION_REQUEST)
	return Set(usedin)
}


/// obtains the status of a given work request
/// - Parameter workRequest: work requesrt
/// - Throws: multipleActionRequestStatus
/// - Returns: work request status
/// 
/// # Reference
/// 15.1 Request for Work;
/// 15.1.1.1 versioned_action_request;
/// 15.1.1.2 action_request_status;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func status(of workRequest: ap242.eVERSIONED_ACTION_REQUEST) throws -> ap242.eACTION_REQUEST_STATUS? {
	let usedin = SDAI.USEDIN(
		T: workRequest, 
		ROLE: \ap242.eACTION_REQUEST_STATUS.ASSIGNED_REQUEST)
	guard usedin.size <= 1 else {
		throw PDMkitError.multipleActionRequestStatus(usedin.asSwiftType)
	}
	let status = usedin[1]
	return status
}


/// obtains work requests raised against a given item
/// - Parameter item: item
/// - Returns: work requests
/// 
/// # Reference
/// 15.1 Request for Work;
/// 15.1.1.1 versioned_action_request;
/// 15.1.1.3 applied_action_request_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func workRequests(raisedAgainst item: ap242.sACTION_REQUEST_ITEM) -> Set<ap242.eAPPLIED_ACTION_REQUEST_ASSIGNMENT> {
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \ap242.eAPPLIED_ACTION_REQUEST_ASSIGNMENT.ITEMS)
	return Set(usedin)
}

