//
//  ExternalFile.swift
//  
//
//  Created by Yoshida on 2021/08/24.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains document files contained in a given schema instance
/// - Parameter domain: schema instance
/// - Returns: all document files found
/// 
/// # Reference
/// 7.1 External File Identification;
/// 7.1.1 document_file;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func documentFiles(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.eDOCUMENT_FILE> {
	let instances = domain.entityExtent(type: ap242.eDOCUMENT_FILE.self)
	return Set(instances)
}

/// obtains document files associated with a given product definition
/// - Parameter documentProductDefinition: document product definition
/// - Returns: document files
/// 
/// # Reference
/// 8.1 Product Definition with associated documents;
/// 8.1.1 product_definition_with_associated_documents;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func documentFiles(for documentProductDefinition: ap242.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS) -> Set<ap242.eDOCUMENT_FILE> {
	let documentIds = documentProductDefinition.DOCUMENTATION_IDS
	let documentFiles = documentIds.compactMap{ ap242.eDOCUMENT_FILE.cast(from: $0) }
	return Set(documentFiles)
}




/// obtains the representation type of a given document file
/// - Parameter documentFile: document file
/// - Throws: multipleDocumentRepresentationTypes
/// - Returns: representation type
/// 
/// # Reference
/// 7.1 External File Identification;
/// 7.1.1 document_file;
/// 7.1.2 document_representation_type;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func representationType(of documentFile: ap242.eDOCUMENT_FILE?) throws -> ap242.eDOCUMENT_REPRESENTATION_TYPE? {
	let usedin = Set(SDAI.USEDIN(
		T: documentFile, 
		ROLE: \ap242.eDOCUMENT_REPRESENTATION_TYPE.REPRESENTED_DOCUMENT) )
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleDocumentRepresentationTypes(usedin)
	}
	return usedin.first
}



/// obtains the type of a given document file
/// - Parameter documentFile: document file
/// - Returns: document type
/// 
/// # Reference
/// 7.1 External File Identification;
/// 7.1.1 document_file;
/// 7.1.3 document_type;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func type(of documentFile: ap242.eDOCUMENT_FILE) -> ap242.eDOCUMENT_TYPE {
	let type = documentFile.KIND
	return type
}


/// obtains the version of a given document file
/// - Parameter documentFile: document file
/// - Throws: multipleAssignedVersions
/// - Returns: version identification
/// 
/// # Reference
/// 7.1 External File Identification;
/// 7.1.1 document_file;
/// 7.1.3 document_type;
/// 7.1.4 applied_identification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func version(of documentFile: ap242.eDOCUMENT_FILE?) throws -> ap242.eAPPLIED_IDENTIFICATION_ASSIGNMENT? {
	let usedin = Set(SDAI.USEDIN(
		T: documentFile, 
		ROLE: \ap242.eAPPLIED_IDENTIFICATION_ASSIGNMENT.ITEMS) )
	let versions = usedin.filter{ $0.ROLE.NAME == "version" }
	guard versions.count <= 1 else {
		throw PDMkitError.multipleAssignedVersions(versions)
	}
	return versions.first
}

