//
//  Organization.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains all organizations contained in a schema instance (13.1.1.1)
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
///
public func organizations(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eORGANIZATION.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eORGANIZATION.self)
	return Set( instances.map{$0.pRef} )
}


/// obtains items assigned to a given organization (13.1.1.2)
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
///
public func items(
	assignedTo organization: apPDM.eORGANIZATION.PRef?
) -> Set<apPDM.eAPPLIED_ORGANIZATION_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: organization, 
		ROLE: \apPDM.eAPPLIED_ORGANIZATION_ASSIGNMENT.ASSIGNED_ORGANIZATION) 
	return Set(usedin)
}

/// obtains organizations assigned to a given item (13.1.1.2)
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
///
public func organizations(
	assignedTo item: apPDM.sORGANIZATION_ITEM?
) -> Set<apPDM.eAPPLIED_ORGANIZATION_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_ORGANIZATION_ASSIGNMENT.ITEMS)
	return Set(usedin)
}

