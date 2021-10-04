//
//  File.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains all organizations contained in a schema instance
/// - Parameter domain: schema instance
/// - Returns: all organizations found
/// 
/// # Reference
/// 13.1 Organization and Person;
/// 13.1.1 Organization;
/// 13.1.1.1 organization;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func orgainizations(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.eORGANIZATION> {
	let instances = domain.entityExtent(type: ap242.eORGANIZATION.self)
	return Set(instances)
}


/// obtains items assigned to a given origanization
/// - Parameter organization: organization
/// - Returns: assigned items
/// 
/// # Reference
/// 13.1 Organization and Person;
/// 13.1.1 Organization;
/// 13.1.1.2 applied_organization_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func items(assignedTo organization: ap242.eORGANIZATION) -> Set<ap242.eAPPLIED_ORGANIZATION_ASSIGNMENT> {
	if let usedin = SDAI.USEDIN(
			T: organization, 
			ROLE: \ap242.eAPPLIED_ORGANIZATION_ASSIGNMENT.ASSIGNED_ORGANIZATION) {
		return Set(usedin)
	}
	return []
}

/// obtains organizations assigned to a given item
/// - Parameter item: item
/// - Returns: assigned organizations
/// 
/// # Reference
/// 13.1 Organization and Person;
/// 13.1.1 Organization;
/// 13.1.1.2 applied_organization_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func organizations(assignedTo item: ap242.sORGANIZATION_ITEM) -> Set<ap242.eAPPLIED_ORGANIZATION_ASSIGNMENT> {
	if let usedin = SDAI.USEDIN(
			T: item, 
			ROLE: \ap242.eAPPLIED_ORGANIZATION_ASSIGNMENT.ITEMS) {
		return Set(usedin)
	}
	return []
}
