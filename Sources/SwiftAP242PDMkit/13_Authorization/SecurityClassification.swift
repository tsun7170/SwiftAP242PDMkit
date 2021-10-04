//
//  File.swift
//  
//
//  Created by Yoshida on 2021/08/28.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains the security classifications assigned to a given item
/// - Parameter item: item
/// - Returns: security classifications
/// 
/// # Reference
/// 13.4 Security classification;
/// 13.4.1.3 applied_security_classification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func securityClassifications(for item: ap242.sSECURITY_CLASSIFICATION_ITEM) -> Set<ap242.eAPPLIED_SECURITY_CLASSIFICATION_ASSIGNMENT> {
	if let usedin = SDAI.USEDIN(T: item, ROLE: \ap242.eAPPLIED_SECURITY_CLASSIFICATION_ASSIGNMENT.ITEMS) {
		return Set(usedin)
	}
	return []
}