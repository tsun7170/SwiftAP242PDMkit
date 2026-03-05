//
//  DocumentAssociationToProductData.swift
//  
//
//  Created by Yoshida on 2021/08/24.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore


//MARK: - Document Reference


/// obtains associated documents for a given product definition (10.1.4)
/// - Parameter productDefinition: product definition
/// - Returns: document references
/// 
/// # Reference
/// 10.1 Document Reference;
/// 10.1.4 applied_document_reference;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func associatedDocuments(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.eAPPLIED_DOCUMENT_REFERENCE.PRef>
{
	if let item = apPDM.sDOCUMENT_REFERENCE_ITEM(productDefinition) {
		return associatedDocuments(of: item)
	}
	return []
}

/// obtains associated documents for a given generic item (10.1.4)
/// - Parameter item: generic item
/// - Returns: document references
/// 
/// # Reference
/// 10.1 Document Reference;
/// 10.1.4 applied_document_reference;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func associatedDocuments(
	of item: apPDM.sDOCUMENT_REFERENCE_ITEM?
) -> Set<apPDM.eAPPLIED_DOCUMENT_REFERENCE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_DOCUMENT_REFERENCE.ITEMS) 
	return Set(usedin)
}


/// obtains a managed document product for a given document reference (10.1.1-2,.4)
/// - Parameter documentReference: document reference
/// - Throws: multipleDocumentProductEquivalences
/// - Returns: managed document product if associated
/// 
/// # Reference
/// 10.1 Document Reference;
/// 10.1.1 document_product_equivalence;
/// 10.1.2 document;
/// 10.1.4 applied_document_reference;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func managedDocument(
	of documentReference: apPDM.eAPPLIED_DOCUMENT_REFERENCE.PRef
) throws -> apPDM.sPRODUCT_OR_FORMATION_OR_DEFINITION?
{
	let document = documentReference.ASSIGNED_DOCUMENT
	return try managedDocument(of: document)
}


/// obtains a managed document product for a given document (10.1.1-2)
/// - Parameter document: document
/// - Throws: multipleDocumentProductEquivalences
/// - Returns: managed document product if associated
/// 
/// # Reference
/// 10.1 Document Reference;
/// 10.1.1 document_product_equivalence;
/// 10.1.2 document;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func managedDocument(
	of document: apPDM.eDOCUMENT.PRef?
) throws -> apPDM.sPRODUCT_OR_FORMATION_OR_DEFINITION?
{
	let usedin = Set(SDAI.USEDIN(
		T: document, 
		ROLE: \apPDM.eDOCUMENT_PRODUCT_EQUIVALENCE.RELATING_DOCUMENT))
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleDocumentProductEquivalences(usedin)
	}
	let managedDoc = usedin.first?.RELATED_PRODUCT
	return managedDoc
}


/// obtains a unmanaged document file for a given document reference (10.2)(10.1.4)(7.1.1)
/// - Parameter documentReference: document reference
/// - Returns: document file if associated
/// 
/// # Reference
/// 10.2 External File Reference;
/// 10.1.4 applied_document_reference;
/// 7.1.1 document_file;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func documentFile(
	of documentReference: apPDM.eAPPLIED_DOCUMENT_REFERENCE.PRef
) -> apPDM.eDOCUMENT_FILE.PRef?
{
	let document = documentReference.ASSIGNED_DOCUMENT
	return documentFile(as: document)
}


/// obtains a unmanaged document file from a given document (10.2)(7.1.1)
/// - Parameter document: document
/// - Returns: equivalent document file if possible
/// 
/// # Reference
/// 10.2 External File Reference;
/// 7.1.1 document_file;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func documentFile(
	as document: apPDM.eDOCUMENT.PRef?
) -> apPDM.eDOCUMENT_FILE.PRef?
{
	let docFile = document?.sub_eDOCUMENT_FILE
	return docFile?.pRef
}


/// obtains the gateway document references equivalenced to document products from a given document file (8.1)(10.1.1)(10.2)
/// - Parameter documentFile: document file
/// - Returns: gateway document references
/// 
/// # Reference
/// 8.1 Product Definition with associated documents;
/// 10.1 Document Reference;
/// 10.1.1 document_product_equivalence;
/// 10.2 External File Reference;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func documentReferences(
	of documentFile: apPDM.eDOCUMENT_FILE.PRef
) -> Set<apPDM.eDOCUMENT.PRef>
{
	var result:Set<apPDM.eDOCUMENT.PRef> = [SDAI.UNWRAP(documentFile.super_eDOCUMENT?.pRef)]

	let usedin = SDAI.USEDIN(
		T: documentFile, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.DOCUMENTATION_IDS) 
	
	for definition in usedin {
		let usedin =
		SDAI.USEDIN(
			T: definition,
			ROLE: \apPDM.eDOCUMENT_PRODUCT_EQUIVALENCE.RELATED_PRODUCT).asSwiftType
		+
		SDAI.USEDIN(
			T: definition.FORMATION,
			ROLE: \apPDM.eDOCUMENT_PRODUCT_EQUIVALENCE.RELATED_PRODUCT).asSwiftType
		+
		SDAI.USEDIN(
			T: definition.FORMATION?.OF_PRODUCT,
			ROLE: \apPDM.eDOCUMENT_PRODUCT_EQUIVALENCE.RELATED_PRODUCT).asSwiftType

		result.formUnion(usedin.compactMap({$0.RELATING_DOCUMENT}))
	}
	return result
}


/// obtains applications of given document references (10.1.4)
/// - Parameter documentReferences: document references
/// - Returns: all applications
/// 
/// # Reference
/// 10.1 Document Reference;
/// 10.1.4 applied_document_reference;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func applications(
	of documentReferences:Set<apPDM.eDOCUMENT.PRef>
) -> Set<apPDM.eAPPLIED_DOCUMENT_REFERENCE.PRef>
{
	var result:Set<apPDM.eAPPLIED_DOCUMENT_REFERENCE.PRef> = []

	for document in documentReferences {
		let usedin = SDAI.USEDIN(
			T: document, 
			ROLE: \apPDM.eAPPLIED_DOCUMENT_REFERENCE.ASSIGNED_DOCUMENT)

		result.formUnion(usedin)
	}

	return result
}

/// obtains applications as the externally defined definitional shape of parts of given document references (3.2.3)
/// - Parameter documentReferences: document references
/// - Returns: all applications to shape representation property
///
/// # Reference
/// 3.2.3 Relating Externally Defined Part Shape to an External File
///
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func definitionalShapeApplications(
	of documentReferences:Set<apPDM.eDOCUMENT.PRef>
) -> Set<apPDM.ePROPERTY_DEFINITION_REPRESENTATION.PRef>
{
	var result:Set<apPDM.ePROPERTY_DEFINITION_REPRESENTATION.PRef> = []

	for document in documentReferences {
		let usedin = SDAI.USEDIN(
			T: document, 
			ROLE: \apPDM.ePROPERTY_DEFINITION.DEFINITION) 
		
		for externalDefinition in
					usedin.filter({ $0.NAME?.asSwiftType == "external definition" })
		{
			let usedin = SDAI.USEDIN(
				T: externalDefinition,
				ROLE: \apPDM.ePROPERTY_DEFINITION_REPRESENTATION.DEFINITION)
			result.formUnion(usedin)
		}
	}
	return result
}

//MARK: - Constrained Document or File Reference


/// obtains portions of documents associated with a given product definition (10.3.2)
/// - Parameter productDefinition: product definition
/// - Returns: portions of documents
/// 
/// # Reference
/// 10.3 Constrained Document or File Reference;
/// 10.3.2 applied_document_usage_constraint_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func associatedDocumentPortions(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.eAPPLIED_DOCUMENT_USAGE_CONSTRAINT_ASSIGNMENT.PRef>
{
	if let item = apPDM.sDOCUMENT_REFERENCE_ITEM(productDefinition) {
		return associatedDocumentPortions(of: item)
	}
	return []
}

/// obtains portions of documents associated with a generic item (10.3.2)
/// - Parameter item: generic item
/// - Returns: portions of documents
/// 
/// # Reference
/// 10.3 Constrained Document or File Reference;
/// 10.3.2 applied_document_usage_constraint_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func associatedDocumentPortions(
	of item: apPDM.sDOCUMENT_REFERENCE_ITEM?
) -> Set<apPDM.eAPPLIED_DOCUMENT_USAGE_CONSTRAINT_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: item, 
		ROLE: \apPDM.eAPPLIED_DOCUMENT_USAGE_CONSTRAINT_ASSIGNMENT.ITEMS)
	return Set(usedin)
}


/// obtains a managed document product for a given portion of document usage (10.3.1-2)
/// - Parameter documentUsageConstraint: portion of document usage
/// - Throws: multipleDocumentProductEquivalences
/// - Returns: managed document product if associated
/// 
/// # Reference
/// 10.3 Constrained Document or File Reference;
/// 10.3.2 applied_document_usage_constraint_assignment;
/// 10.3.1 document_usage_constraint;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func managedDocument(
	of documentUsageConstraint: apPDM.eDOCUMENT_USAGE_CONSTRAINT.PRef
) throws -> apPDM.sPRODUCT_OR_FORMATION_OR_DEFINITION?
{
	let document = documentUsageConstraint.SOURCE
	return try managedDocument(of: document)
}

/// obtains a unmanaged document file for a given portion of document usage (10.3.1-2)
/// - Parameter documentUsageConstraint: portion of document usage
/// - Returns: unmanaged document file
/// 
/// # Reference
/// 10.3 Constrained Document or File Reference;
/// 10.3.2 applied_document_usage_constraint_assignment;
/// 10.3.1 document_usage_constraint;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func documentFile(
	of documentUsageConstraint: apPDM.eDOCUMENT_USAGE_CONSTRAINT.PRef
) -> apPDM.eDOCUMENT_FILE.PRef?
{
	let document = documentUsageConstraint.SOURCE
	return documentFile(as: document)
}
