//
//  GeneralPropertyIdentification.swift
//  
//
//  Created by Yoshida on 2021/08/22.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains all general property types in the schema instance (3.1.2.1)
/// - Parameter domain: schema instance
/// - Returns: all general property types found
/// 
/// # Reference
/// 3.1.2 Independent Property Identification;
/// 3.1.2.1 General_property;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func generalProperties(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eGENERAL_PROPERTY.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eGENERAL_PROPERTY.self)
	return Set( instances.map{$0.pRef} )
}


/// obtains all property definitions associated with a given general property type (3.1.2.2)
/// - Parameter generalPropertyType: general property type
/// - Returns: all property associations
/// 
/// # Reference
/// 3.1.2 Independent Property Identification;
/// 3.1.2.2 general_property_association;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func associations(
	of generalPropertyType: apPDM.eGENERAL_PROPERTY.PRef?
) -> Set<apPDM.eGENERAL_PROPERTY_ASSOCIATION.PRef>
{
	let usedin = SDAI.USEDIN(
		T: generalPropertyType, 
		ROLE: \apPDM.eGENERAL_PROPERTY_ASSOCIATION.BASE_DEFINITION) 
	return Set(usedin)
}


/// obtains the property definition assigned to a given property association (3.1.2.2)
/// - Parameter generalPropertyAssociation: property association
/// - Returns: property definition
/// 
/// # Reference
/// 3.1.2 Independent Property Identification;
/// 3.1.2.2 general_property_association;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func propertyDefinition(
	of generalPropertyAssociation: apPDM.eGENERAL_PROPERTY_ASSOCIATION.PRef
) -> apPDM.sDERIVED_PROPERTY_SELECT
{
	let propDef = generalPropertyAssociation.DERIVED_DEFINITION
	return SDAI.UNWRAP(propDef)
}


/// obtains all related general property types of a relating general property type (3.1.2.3)
/// - Parameter generalPropertyType: relating general property type
/// - Returns: all related general property types
/// 
/// # Reference
/// 3.1.2 Independent Property Identification;
/// 3.1.2.3 general_property_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatedGeneralProperties(
	of generalPropertyType: apPDM.eGENERAL_PROPERTY.PRef?
) -> Set<apPDM.eGENERAL_PROPERTY_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: generalPropertyType, 
		ROLE: \apPDM.eGENERAL_PROPERTY_RELATIONSHIP.RELATING_PROPERTY) 
	return Set(usedin)
}


/// obtains all relating general property types of a related general property type (3.1.2.3)
/// - Parameter generalPropertyType: related general property type
/// - Returns: all relating general property types
/// 
/// # Reference
/// 3.1.2 Independent Property Identification;
/// 3.1.2.3 general_property_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func relatingGeneralProperties(
	of generalPropertyType: apPDM.eGENERAL_PROPERTY.PRef?
) -> Set<apPDM.eGENERAL_PROPERTY_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: generalPropertyType, 
		ROLE: \apPDM.eGENERAL_PROPERTY_RELATIONSHIP.RELATED_PROPERTY)
	return Set(usedin)
}

