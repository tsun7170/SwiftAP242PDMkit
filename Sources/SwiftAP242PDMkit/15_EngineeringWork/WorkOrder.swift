//
//  WorkOrder.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242



/// obtains all work order directives contained in a schema instance
/// - Parameter domain: schema instance
/// - Returns: all work order directives found
/// 
/// # Reference
/// 15.2.1 Work Order;
/// 15.2.1.1 action_directive;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func workOrders(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eACTION_DIRECTIVE.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eACTION_DIRECTIVE.self)
	return Set( instances.map{$0.pRef} )
}

/// obtains the work order directives addressing a given work request
/// - Parameter workRequest: work request
/// - Returns: work order directives
/// 
/// # Reference
/// 15.2.1 Work Order;
/// 15.2.1.1 action_directive;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func workOrders(
	for workRequest: apPDM.eVERSIONED_ACTION_REQUEST.PRef?
) -> Set<apPDM.eACTION_DIRECTIVE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: workRequest, 
		ROLE: \apPDM.eACTION_DIRECTIVE.REQUESTS)
	return Set(usedin)
}




/// obtains the work order action controlled by a given work order directive
/// - Parameter workOrder: work order directive
/// - Throws: multipleDirectedActions
/// - Returns: work order action
/// 
/// # Reference
/// 15.2.1 Work Order;
/// 15.2.1.1 action_directive;
/// 15.2.1.2 directed_action;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func directedAction(
	for workOrder: apPDM.eACTION_DIRECTIVE.PRef?
) throws -> apPDM.eDIRECTED_ACTION.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: workOrder, 
		ROLE: \apPDM.eDIRECTED_ACTION.DIRECTIVE))
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleDirectedActions(usedin)
	}
	let action = usedin.first
	return action
}


/// obtains input items for a given work order action
/// - Parameter action: work order action
/// - Returns: input items
/// 
/// # Reference
/// 15.2.1 Work Order;
/// 15.2.1.3 applied_action_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func inputItems(
	for action: apPDM.eACTION.PRef?
) -> Set<apPDM.eAPPLIED_ACTION_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: action, 
		ROLE: \apPDM.eAPPLIED_ACTION_ASSIGNMENT.ASSIGNED_ACTION)
	let inputs = Set(usedin.lazy.filter{ $0.ROLE?.NAME == "input" })
	return inputs
}


/// obtains affected items by a given work order action
/// - Parameter action: work order action
/// - Returns: affected items
/// 
/// # Reference
/// 15.2.1 Work Order;
/// 15.2.1.3 applied_action_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func affectedItems(
	by action: apPDM.eACTION.PRef?
) -> Set<apPDM.eAPPLIED_ACTION_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: action, 
		ROLE: \apPDM.eAPPLIED_ACTION_ASSIGNMENT.ASSIGNED_ACTION) 
	let affected = Set(usedin.lazy.filter{ $0.ROLE?.NAME != "input" })
	return affected
}


/// obtain the status for a given work order action
/// - Parameter action: work order action
/// - Throws: multipleActionStatus
/// - Returns: status
/// 
/// # Reference
/// 15.2.1 Work Order;
/// 15.2.2 Activity decomposition;
/// 15.2.2.2 action_status;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func status(
	for action: apPDM.eEXECUTED_ACTION.PRef?
) throws -> apPDM.eACTION_STATUS.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: action, 
		ROLE: \apPDM.eACTION_STATUS.ASSIGNED_ACTION) )
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleActionStatus(usedin)
	}
	let status = usedin.first
	return status
}


/// obtains the related actions for a given work order action
/// - Parameter action: work order action
/// - Returns: related actions
/// 
/// # Reference
/// 15.2.1 Work Order;
/// 15.2.2 Activity decomposition;
/// 15.2.2.3 action_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatedActions(
	for action: apPDM.eACTION.PRef?
) -> Set<apPDM.eACTION_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: action, 
		ROLE: \apPDM.eACTION_RELATIONSHIP.RELATING_ACTION) 
	return Set(usedin)
}

/// obtains the relating actions for a given work order action
/// - Parameter action: work order action
/// - Returns: relating actions
/// 
/// # Reference
/// 15.2.1 Work Order;
/// 15.2.2 Activity decomposition;
/// 15.2.2.3 action_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatingActions(
	for action: apPDM.eACTION.PRef?
) -> Set<apPDM.eACTION_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: action, 
		ROLE: \apPDM.eACTION_RELATIONSHIP.RELATED_ACTION) 
	return Set(usedin)
}

