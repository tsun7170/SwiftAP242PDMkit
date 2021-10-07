//
//  Approval.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains approvals given to a specified item
/// - Parameter item: item
/// - Returns: approvals
/// 
/// # Reference
/// 13.2 Approval;
/// 13.2.1 Basic Approval;
/// 13.2.1.3 applied_approval_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func approvals(on item: ap242.sAPPROVAL_ITEM) -> Set<ap242.eAPPLIED_APPROVAL_ASSIGNMENT> {
	if let usedin = SDAI.USEDIN(
			T: item, 
			ROLE: \ap242.eAPPLIED_APPROVAL_ASSIGNMENT.ITEMS) {
		return Set(usedin)
	}
	return []
}


/// obtains the responsibles for a given approval
/// - Parameter approval: approval
/// - Returns: responsibles
/// 
/// # Reference
/// 13.2.2 Approval Cycles and Multiple Sign-off Scenarios;
/// 13.2.1.4 approval_persion_organizaion;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func responsibles(for approval: ap242.eAPPROVAL) -> Set<ap242.eAPPROVAL_PERSON_ORGANIZATION> {
	if let usedin = SDAI.USEDIN(
			T: approval, 
			ROLE: \ap242.eAPPROVAL_PERSON_ORGANIZATION.AUTHORIZED_APPROVAL) {
		return Set(usedin)
	}
	return []
}


/// obtains the related dates of a given approval
/// - Parameter approval: approval
/// - Returns: dates
/// 
/// # Reference
/// 13.2.1 Basic Approval;
/// 13.2.1.6 approval_date_time;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func approvalDates(for approval: ap242.eAPPROVAL) -> Set<ap242.eAPPROVAL_DATE_TIME> {
	if let usedin = SDAI.USEDIN(
			T: approval, 
			ROLE: \ap242.eAPPROVAL_DATE_TIME.DATED_APPROVAL) {
		return Set(usedin)
	}
	return []
}


/// obtains the sub-approvals related to a given master approval
/// - Parameter approval: master approval
/// - Returns: sub-approvals
/// 
/// # Reference
/// 13.2.2 Approval Cycles and Multiple Sign-off Scenarios;
/// 13.2.2.1 approval_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatedApprovals(to approval: ap242.eAPPROVAL) -> Set<ap242.eAPPROVAL_RELATIONSHIP> {
	if let usedin = SDAI.USEDIN(T: approval, ROLE: \ap242.eAPPROVAL_RELATIONSHIP.RELATING_APPROVAL) {
		return Set(usedin)
	}
	return []
}

/// obtains the master-approvals relating to a given sub-approval
/// - Parameter approval: sub-approval
/// - Returns: master-approvals
/// 
/// # Reference
/// 13.2.2 Approval Cycles and Multiple Sign-off Scenarios;
/// 13.2.2.1 approval_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatingApprovals(to approval: ap242.eAPPROVAL) -> Set<ap242.eAPPROVAL_RELATIONSHIP> {
	if let usedin = SDAI.USEDIN(T: approval, ROLE: \ap242.eAPPROVAL_RELATIONSHIP.RELATED_APPROVAL) {
		return Set(usedin)
	}
	return []
}
