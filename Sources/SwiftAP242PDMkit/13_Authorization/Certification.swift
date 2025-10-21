//
//  Certification.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains all certifications in the schema instance
/// - Parameter domain: schema instance
/// - Returns: certifications
/// 
/// # Reference
/// 13.5 Certification;
/// 13.5.1.1 certification;
/// 13.5.1.2 applied_certification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func certifications(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eCERTIFICATION.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eCERTIFICATION.self)
	return Set( instances.map{$0.pRef} )
}


/// obtains items certified by a given certification
/// - Parameter certification: certification
/// - Returns: certified items
/// 
/// # Reference
/// 13.5 Certification;
/// 13.5.1.2 applied_certification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func certifiedItems(
	by certification: apPDM.eCERTIFICATION.PRef?
) -> Set<apPDM.eAPPLIED_CERTIFICATION_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: certification, 
		ROLE: \apPDM.eAPPLIED_CERTIFICATION_ASSIGNMENT.ASSIGNED_CERTIFICATION) 
	return Set(usedin)
}

/// obtains certifications given to an certified item
/// - Parameter item: certified item
/// - Returns: certifications
/// 
/// # Reference
/// 13.5 Certification;
/// 13.5.1.2 applied_certification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func certifications(
	for item: apPDM.sCERTIFIED_ITEM?
) -> Set<apPDM.eAPPLIED_CERTIFICATION_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_CERTIFICATION_ASSIGNMENT.ITEMS) 
	return Set(usedin)
}

