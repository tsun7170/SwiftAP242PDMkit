//
//  Project.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242



/// obtains all projects contained in a schema instance
/// - Parameter domain: schema instance
/// - Returns: all projects found
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.1.1 organizational_project;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func projects(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eORGANIZATIONAL_PROJECT.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eORGANIZATIONAL_PROJECT.self)
	return Set( instances.map{$0.pRef} )
}


/// obtains the projects assigned to a given product concept
/// - Parameter productConcept: product concept
/// - Returns: project assignments
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.1.1 organizational_project;
/// 15.3.1.2 applied_organizational_project_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func projects(
	assignedTo productConcept: apPDM.ePRODUCT_CONCEPT.PRef?
) -> Set<apPDM.eAPPLIED_ORGANIZATIONAL_PROJECT_ASSIGNMENT.PRef>
{
	if let item = apPDM.sPROJECT_ITEM(productConcept) {
		return projects(assignedTo: item)
	}
	return []
}

/// obtains the projects assigned to a given item
/// - Parameter item: item
/// - Returns: project assignments
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.1.1 organizational_project;
/// 15.3.1.2 applied_organizational_project_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func projects(
	assignedTo item: apPDM.sPROJECT_ITEM?
) -> Set<apPDM.eAPPLIED_ORGANIZATIONAL_PROJECT_ASSIGNMENT.PRef>
{
	let udedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_ORGANIZATIONAL_PROJECT_ASSIGNMENT.ITEMS) 
	return Set(udedin)
}



/// obtains the product concepts related to a gicen project
/// - Parameter project: project
/// - Returns: product concepts
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.1.1 organizational_project;
/// 15.3.1.2 applied_organizational_project_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func productConcepts(
	relatedTo project: apPDM.eORGANIZATIONAL_PROJECT.PRef?
) -> Set<apPDM.ePRODUCT_CONCEPT.PRef>
{
	let data = productData(relatedTo: project)
	let productConcepts = data.flatMap { projAssignment in
		let items = projAssignment.ITEMS
		let mapped = items?.compactMap { projItem in
			apPDM.ePRODUCT_CONCEPT.convert(sibling: projItem.entityReference)?.pRef
		} ?? []
		return mapped
	}
	return Set( productConcepts )
}

/// obtains the product data related to a given project
/// - Parameter project: project
/// - Returns: related product data assignments
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.1.1 organizational_project;
/// 15.3.1.2 applied_organizational_project_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func productData(
	relatedTo project: apPDM.eORGANIZATIONAL_PROJECT.PRef?
) -> Set<apPDM.eAPPLIED_ORGANIZATIONAL_PROJECT_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: project, 
		ROLE: \apPDM.eAPPLIED_ORGANIZATIONAL_PROJECT_ASSIGNMENT.ASSIGNED_ORGANIZATIONAL_PROJECT) 
	return Set(usedin)
}


/// obtains projects related to a given project
/// - Parameter project: project
/// - Returns: related projects
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.1.1 organizational_project;
/// 15.3.1.4 organizational_project_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatedProjects(
	for project: apPDM.eORGANIZATIONAL_PROJECT.PRef?
) -> Set<apPDM.eORGANIZATIONAL_PROJECT_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: project, 
		ROLE: \apPDM.eORGANIZATIONAL_PROJECT_RELATIONSHIP.RELATING_ORGANIZATIONAL_PROJECT)
	return Set(usedin)
}

/// obtains projects relating to a given project
/// - Parameter project: project
/// - Returns: relating projects
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.1.1 organizational_project;
/// 15.3.1.4 organizational_project_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatingProjects(
	for project: apPDM.eORGANIZATIONAL_PROJECT.PRef?
) -> Set<apPDM.eORGANIZATIONAL_PROJECT_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: project, 
		ROLE: \apPDM.eORGANIZATIONAL_PROJECT_RELATIONSHIP.RELATED_ORGANIZATIONAL_PROJECT)
	return Set(usedin)
}



/// obtains the activities assigned to a given project
/// - Parameter project: project
/// - Returns: assigned activities
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.2 Assignment of activities to projects;
/// 15.3.2.1 applied_organizational_project_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func activities(
	assignedTo project: apPDM.eORGANIZATIONAL_PROJECT.PRef?
) -> Set<apPDM.eAPPLIED_ORGANIZATIONAL_PROJECT_ASSIGNMENT.PRef>
{
	return productData(relatedTo: project)
}


/// obtains date events associated to a given project
/// - Parameter project: project
/// - Returns: associated date events
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.3 Start and end date and time of projects;
/// 15.3.3.2 applied_date_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func definedDateEvents(
	for project: apPDM.eORGANIZATIONAL_PROJECT.PRef?
) -> Set<apPDM.eAPPLIED_DATE_ASSIGNMENT.PRef>
{
	if let item = apPDM.sDATE_ITEM(project) {
		return definedDateEvents(for: item)
	}
	return []
}

/// obtains the date events associated with a given item
/// - Parameter item: item
/// - Returns: associated date events
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.3 Start and end date and time of projects;
/// 15.3.3.2 applied_date_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func definedDateEvents(
	for item: apPDM.sDATE_ITEM?
) -> Set<apPDM.eAPPLIED_DATE_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_DATE_ASSIGNMENT.ITEMS)
	return Set(usedin)
}


/// obtains the date and time events associated with a given project
/// - Parameter project: project
/// - Returns: associated date and time events
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.3 Start and end date and time of projects;
/// 15.3.3.4 applied_date_and_time_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func definedDateTimeEvents(
	for project: apPDM.eORGANIZATIONAL_PROJECT.PRef?
) -> Set<apPDM.eAPPLIED_DATE_AND_TIME_ASSIGNMENT.PRef>
{
	if let item = apPDM.sDATE_TIME_ITEM(project) {
		return definedDateTimeEvents(for: item)
	}
	return []
}

/// obtains the date and time events associated with a given item
/// - Parameter item: item
/// - Returns: associated date and time events
/// 
/// # Reference
/// 15.3 Project Identification;
/// 15.3.3 Start and end date and time of projects;
/// 15.3.3.4 applied_date_and_time_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func definedDateTimeEvents(
	for item: apPDM.sDATE_TIME_ITEM?
) -> Set<apPDM.eAPPLIED_DATE_AND_TIME_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_DATE_AND_TIME_ASSIGNMENT.ITEMS)
	return Set(usedin)
}


