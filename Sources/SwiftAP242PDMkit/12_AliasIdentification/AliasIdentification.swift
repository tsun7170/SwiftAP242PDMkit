//
//  AliasIdentification.swift
//  
//
//  Created by Yoshida on 2021/08/26.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains aliases assgined to a given item
/// - Parameter item: item
/// - Returns: aliases
/// 
/// # Reference
/// 12 Alias Identification;
/// 12.1.1.1 applied_identification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func aliases(for item:ap242.sIDENTIFICATION_ITEM) -> Set<ap242.eAPPLIED_IDENTIFICATION_ASSIGNMENT> {
	if let usedin = SDAI.USEDIN(
			T: item, 
			ROLE: \ap242.eAPPLIED_IDENTIFICATION_ASSIGNMENT.ITEMS) {
		let aliaes = usedin.filter{ $0.ROLE.NAME == "alias" }
		return Set(aliaes)
	}
	return []
}
