//
//  DocumentSourceProperty.swift
//  
//
//  Created by Yoshida on 2021/08/24.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
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
public func fileLocations(of documentFile: ap242.eDOCUMENT_FILE) -> [DocumentSourceProperty] {
	let AEIAs = sourceProperties(of: documentFile)
	if !AEIAs.isEmpty {
		var fileIds:[DocumentSourceProperty] = []
		for AEIA in AEIAs {
			if AEIA.ASSIGNED_ID.asSwiftType == "" {
				let fileId = DocumentSourceProperty(
					fileName: AEIA.SOURCE.SOURCE_ID.stringValue?.asSwiftType ?? "", 
					path: nil as String?, 
					mechanism: AEIA.ROLE.NAME.asSwiftType)
				fileIds.append(fileId)
			}
			else {
				let fileId = DocumentSourceProperty(
					fileName: AEIA.ASSIGNED_ID.asSwiftType, 
					path: AEIA.SOURCE.SOURCE_ID.stringValue?.asSwiftType, 
					mechanism: AEIA.ROLE.NAME.asSwiftType)
				fileIds.append(fileId)
			}
		}
		return fileIds
	}
	else {
		let fileId = DocumentSourceProperty(
			fileName: documentFile.ID.asSwiftType, 
			path: nil, 
			mechanism: nil)
		return [fileId]
	}
}

/// specification of location of a document object
/// 
/// # Reference
/// 9.6 Document source property;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public struct DocumentSourceProperty: Equatable {
	var fileName: String
	var path: String?
	var mechanism: String?
	
	public init(fileName: String, path: String?, mechanism: String?) {
		self.fileName = fileName
		self.path = path
		self.mechanism = mechanism
	}
	
	public init(url: URL) {
		self.fileName = url.lastPathComponent
		self.path = url.deletingLastPathComponent().path
		self.mechanism = "URL"
	}
}


/// obtains the document format of a given document file
/// - Parameter documentFile: document file
/// - Throws: multiplePropertyDefinitions, multiplePropertyRepresentations
/// - Returns: document format property representation
/// 
/// # Reference
/// 2.3 Document Format Properties
/// 
/// Recommended Practices for External References; 
/// with References to the PDM Schema Usage Guide; 
/// Release 2.1, Jan. 19, 2005;
/// PDM Implementor Forum 
public func documentFormat(of documentFile: ap242.eDOCUMENT_FILE) throws -> ap242.eREPRESENTATION? {
	let documentProperties = properties(of: documentFile)
		.filter{ $0.NAME == "document property" }
	
	guard documentProperties.count <= 1 else {
		throw PDMkitError.multiplePropertyDefinitions(Array(documentProperties))
	}
	
	let rep = try representation(of: documentProperties.first)
	return rep
}
