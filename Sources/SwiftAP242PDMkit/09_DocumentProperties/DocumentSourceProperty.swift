//
//  File.swift
//  
//
//  Created by Yoshida on 2021/08/24.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242



/// obtains the source properties of a given document file
/// - Parameter documentFile: document file
/// - Returns: source properties
/// 
/// # Reference
/// 9.6 Document source property;
/// 9.6.2 applied_external_identification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func sourceProperties(of documentFile: ap242.eDOCUMENT_FILE) -> Set<ap242.eAPPLIED_EXTERNAL_IDENTIFICATION_ASSIGNMENT> {
	if let extItem = ap242.sEXTERNAL_IDENTIFICATION_ITEM(documentFile) {
		return sourceProperties(of: extItem)
	}
	return []
}

/// obtains the source properties of a given product definition
/// - Parameter productDefinition: product definition
/// - Returns: source properties
/// 
/// # Reference
/// 9.6 Document source property;
/// 9.6.2 applied_external_identification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func sourceProperties(of productDefinition: ap242.ePRODUCT_DEFINITION)-> Set<ap242.eAPPLIED_EXTERNAL_IDENTIFICATION_ASSIGNMENT> {
	if let extItem = ap242.sEXTERNAL_IDENTIFICATION_ITEM(productDefinition) {
		return sourceProperties(of: extItem)
	}
	return []
}

/// obtains the source properties of a generic external identification item
/// - Parameter externalIdentificationItem: external identificatino item
/// - Returns: source properties
/// 
/// # Reference
/// 9.6 Document source property;
/// 9.6.2 applied_external_identification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func sourceProperties(of externalIdentificationItem: ap242.sEXTERNAL_IDENTIFICATION_ITEM)-> Set<ap242.eAPPLIED_EXTERNAL_IDENTIFICATION_ASSIGNMENT> {
	if let usedin = SDAI.USEDIN(
			T: externalIdentificationItem, 
			ROLE: \ap242.eAPPLIED_EXTERNAL_IDENTIFICATION_ASSIGNMENT.ITEMS) {
		return Set(usedin)
	}
	return []
}



/// obtains the file location info of a given document file, according to the recommended practice
/// - Parameter documentFile: document file
/// - Returns: file location info
/// 
/// # Reference
/// 2.1 Placement of the file name;
/// 
/// Recommended Practices for External References; 
/// with References to the PDM Schema Usage Guide; 
/// Release 2.1, Jan. 19, 2005;
/// PDM Implementor Forum 
public func fileLocation(of documentFile: ap242.eDOCUMENT_FILE) -> [(fileName:String, path:String?, mechanism:String?)] {
	let AEIAs = sourceProperties(of: documentFile)
	if !AEIAs.isEmpty {
		var fileIds:[(fileName:String, path:String?, mechanism:String?)] = []
		for AEIA in AEIAs {
			if AEIA.ASSIGNED_ID.asSwiftType == "" {
				let fileId = (fileName:AEIA.SOURCE.SOURCE_ID.stringValue?.asSwiftType ?? "", 
											path:nil as String?, 
											mechanism:AEIA.ROLE.NAME.asSwiftType)
				fileIds.append(fileId)
			}
			else {
				let fileId = (fileName:AEIA.ASSIGNED_ID.asSwiftType, 
											path:AEIA.SOURCE.SOURCE_ID.stringValue?.asSwiftType, 
											mechanism:AEIA.ROLE.NAME.asSwiftType)
				fileIds.append(fileId)
			}
		}
		return fileIds
	}
	else {
		let fileId:(fileName:String, path:String?, mechanism:String?) = (fileName:documentFile.ID.asSwiftType, path:nil, mechanism:nil)
		return [fileId]
	}
}
