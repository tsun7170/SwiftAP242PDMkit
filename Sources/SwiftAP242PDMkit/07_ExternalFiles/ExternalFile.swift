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


/// obtains document files contained in a given schema instance (7.1.1)
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
///
public func documentFiles(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eDOCUMENT_FILE.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eDOCUMENT_FILE.self)
	return Set( instances.map{$0.pRef} )
}

/// obtains document files associated with a given product definition (8.1.1)
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
///
public func documentFiles(
	for documentProductDefinition: apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.PRef
) -> Set<apPDM.eDOCUMENT_FILE.PRef>
{
	guard let documentIds = documentProductDefinition.DOCUMENTATION_IDS
	else { return [] }
	let documentFiles = documentIds.compactMap{ apPDM.eDOCUMENT_FILE.convert(sibling: $0)?.pRef }
	return Set(documentFiles)
}




/// obtains the representation type of a given document file (7.1.1-2)
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
///
public func representationType(
	of documentFile: apPDM.eDOCUMENT_FILE.PRef?
) throws -> apPDM.eDOCUMENT_REPRESENTATION_TYPE.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: documentFile, 
		ROLE: \apPDM.eDOCUMENT_REPRESENTATION_TYPE.REPRESENTED_DOCUMENT) )
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleDocumentRepresentationTypes(usedin)
	}
	return usedin.first
}



/// obtains the type of a given document file (7.1.1,.3)
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
///
public func type(
	of documentFile: apPDM.eDOCUMENT_FILE.PRef
) -> apPDM.eDOCUMENT_TYPE.PRef
{
	let type = documentFile.KIND
	return SDAI.UNWRAP(type)
}


/// obtains the version of a given document file (7.1.1,.3-4)
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
///
public func version(
	of documentFile: apPDM.eDOCUMENT_FILE.PRef?
) throws -> apPDM.eAPPLIED_IDENTIFICATION_ASSIGNMENT.PRef? {
	let usedin = Set(SDAI.USEDIN(
		T: documentFile, 
		ROLE: \apPDM.eAPPLIED_IDENTIFICATION_ASSIGNMENT.ITEMS) )
	let versions = usedin.filter{ $0.ROLE?.NAME == "version" }
	guard versions.count <= 1 else {
		throw PDMkitError.multipleAssignedVersions(versions)
	}
	return versions.first
}

