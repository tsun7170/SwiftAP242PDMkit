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


/// obtains all work requests contained in a schema instance (15.1.1.1)
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
///
public func workRequests(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eVERSIONED_ACTION_REQUEST.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eVERSIONED_ACTION_REQUEST.self)
	return Set( instances.map{$0.pRef} )
}


/// obtains all initial design work requests contained in a schema instance (15.1.1.1)
/// - Parameter domain: schema instance
/// - Returns: all initial design work requests found
///
/// # Reference
/// 15.1 Request for Work;
/// 15.1.1.1 versioned_action_request;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func initialDesignWorkRequests(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eVERSIONED_ACTION_REQUEST.PRef>
{
	let allWorkRequests = workRequests(in: domain)
	let changeWorkRequests = designChangeWorkRequests(in: domain)
		.compactMap{ $0.ASSIGNED_ACTION_REQUEST }
	let initialWorkRequests = allWorkRequests.subtracting(changeWorkRequests)
	return initialWorkRequests
}


/// obtains all design change work requests found in a schema instance (15.1.1.1,.3)
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
///
public func designChangeWorkRequests(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eAPPLIED_ACTION_REQUEST_ASSIGNMENT.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eAPPLIED_ACTION_REQUEST_ASSIGNMENT.self)
	return Set( instances.map{$0.pRef} )
}


/// obtains the potential solutions associated with a given work request (15.1.1.1,.4)
/// - Parameter workRequest: work request
/// - Returns: potential solutions
///
/// # Reference
/// 15.1 Request for Work;
/// 15.1.1.1 versioned_action_request;
/// 15.1.1.4 action_request_solution;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func potentialSolutions(
	for workRequest: apPDM.eVERSIONED_ACTION_REQUEST.PRef?
) -> Set<apPDM.eACTION_REQUEST_SOLUTION.PRef>
{
	let usedin = SDAI.USEDIN(
		T: workRequest, 
		ROLE: \apPDM.eACTION_REQUEST_SOLUTION.REQUEST)
	return Set(usedin)
}


/// obtains change items assigned to a given work request (15.1.1.1,.3)
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
///
public func assignedChangeItems(
	to workRequest: apPDM.eVERSIONED_ACTION_REQUEST.PRef?
) -> Set<apPDM.eAPPLIED_ACTION_REQUEST_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: workRequest, 
		ROLE: \apPDM.eAPPLIED_ACTION_REQUEST_ASSIGNMENT.ASSIGNED_ACTION_REQUEST)
	return Set(usedin)
}


/// obtains the status of a given work request (15.1.1.1-2)
/// - Parameter workRequest: work request
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
///
public func status(
	of workRequest: apPDM.eVERSIONED_ACTION_REQUEST.PRef?
) throws -> apPDM.eACTION_REQUEST_STATUS.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: workRequest, 
		ROLE: \apPDM.eACTION_REQUEST_STATUS.ASSIGNED_REQUEST))
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleActionRequestStatus(usedin)
	}
	let status = usedin.first
	return status
}


/// obtains work requests raised against a given item (15.1.1.1,.3)
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
///
public func workRequests(
	raisedAgainst item: apPDM.sACTION_REQUEST_ITEM?
) -> Set<apPDM.eAPPLIED_ACTION_REQUEST_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_ACTION_REQUEST_ASSIGNMENT.ITEMS)
	return Set(usedin)
}

