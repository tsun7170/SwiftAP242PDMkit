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
public func certifications(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.eCERTIFICATION> {
	let instances = domain.entityExtent(type: ap242.eCERTIFICATION.self)
	return Set(instances)
}


/// obtains items certified by a given certification
/// - Parameter certificaiton: certification
/// - Returns: certified items
/// 
/// # Reference
/// 13.5 Certification;
/// 13.5.1.2 applied_certification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func certifiedItems(by certificaiton: ap242.eCERTIFICATION?) -> Set<ap242.eAPPLIED_CERTIFICATION_ASSIGNMENT> {
	let usedin = SDAI.USEDIN(
		T: certificaiton, 
		ROLE: \ap242.eAPPLIED_CERTIFICATION_ASSIGNMENT.ASSIGNED_CERTIFICATION) 
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
public func certifications(for item: ap242.sCERTIFIED_ITEM?) -> Set<ap242.eAPPLIED_CERTIFICATION_ASSIGNMENT> {
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \ap242.eAPPLIED_CERTIFICATION_ASSIGNMENT.ITEMS) 
	return Set(usedin)
}

