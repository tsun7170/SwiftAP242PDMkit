//
//  File.swift
//  
//
//  Created by Yoshida on 2021/08/24.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242

//MARK: - Document Reference


/// obtains associated documents for a given product definition
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
public func associatedDocuments(of productDefinition: ap242.ePRODUCT_DEFINITION) -> Set<ap242.eAPPLIED_DOCUMENT_REFERENCE> {
	if let item = ap242.sDOCUMENT_REFERENCE_ITEM(productDefinition) {
		return associatedDocuments(of: item)
	}
	return []
}

/// obtains associated documents for a given generic item
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
public func associatedDocuments(of item: ap242.sDOCUMENT_REFERENCE_ITEM) -> Set<ap242.eAPPLIED_DOCUMENT_REFERENCE> {
	if let usedin = SDAI.USEDIN(
			T: item.entityReference, 
			ROLE: \ap242.eAPPLIED_DOCUMENT_REFERENCE.ITEMS) {
		return Set(usedin)
	}
	return []
}


/// obtains a managed document product for a given document reference
/// - Parameter documentReference: document reference
/// - Throws: multipledocumentProductEquivalences
/// - Returns: managed document product if associated
/// 
/// # Reference
/// 10.1 Document Reference;
/// 10.1.1 document_product_qeuqivalence;
/// 10.1.2 document;
/// 10.1.4 applied_document_reference;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func managedDocument(of documentReference: ap242.eAPPLIED_DOCUMENT_REFERENCE) throws -> ap242.sPRODUCT_OR_FORMATION_OR_DEFINITION? {
	let document = documentReference.ASSIGNED_DOCUMENT
	return try managedDocument(of: document)
}


/// obtains a managed document product for a given document
/// - Parameter document: document
/// - Throws: multipledocumentProductEquivalences
/// - Returns: managed document product if associated
/// 
/// # Reference
/// 10.1 Document Reference;
/// 10.1.1 document_product_qeuqivalence;
/// 10.1.2 document;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func managedDocument(of document: ap242.eDOCUMENT) throws -> ap242.sPRODUCT_OR_FORMATION_OR_DEFINITION? {
	if let usedin = SDAI.USEDIN(
			T: document, 
			ROLE: \ap242.eDOCUMENT_PRODUCT_EQUIVALENCE.RELATING_DOCUMENT) {
		guard usedin.size <= 1 else {
			throw PDMkitError.multipleDocumentProductEquivalences(usedin.asSwiftType)
		}
		let managedDoc = usedin[1]?.RELATED_PRODUCT
		return managedDoc
	}
	return nil
}


/// obtains a unmanaged document file for a given document reference
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
public func documentFile(of documentReference: ap242.eAPPLIED_DOCUMENT_REFERENCE) -> ap242.eDOCUMENT_FILE? {
	let document = documentReference.ASSIGNED_DOCUMENT
	return documentFile(as: document)
}


/// obtains a unmanaged document file from a given document
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
public func documentFile(as document: ap242.eDOCUMENT) -> ap242.eDOCUMENT_FILE? {
	let docFile = ap242.eDOCUMENT_FILE.cast(from: document)
	return docFile
}

//MARK: - Constrained Document or File Reference


/// obtains portions of documents associated with a given product definition
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
public func associatedDocumentPortions(of productDefinition: ap242.ePRODUCT_DEFINITION) -> Set<ap242.eAPPLIED_DOCUMENT_USAGE_CONSTRAINT_ASSIGNMENT> {
	if let item = ap242.sDOCUMENT_REFERENCE_ITEM(productDefinition) {
		return associatedDocumentPortions(of: item)
	}
	return []
}

/// obtains portions of documents associated with a generic item
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
public func associatedDocumentPortions(of item: ap242.sDOCUMENT_REFERENCE_ITEM) -> Set<ap242.eAPPLIED_DOCUMENT_USAGE_CONSTRAINT_ASSIGNMENT> {
	if let usedin = SDAI.USEDIN(
			T: item.entityReference, 
			ROLE: \ap242.eAPPLIED_DOCUMENT_USAGE_CONSTRAINT_ASSIGNMENT.ITEMS) {
		return Set(usedin)
	}
	return []
}


/// obtains a managed document product for a given portion of document usage
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
public func managedDocument(of documentUsageConstraint: ap242.eDOCUMENT_USAGE_CONSTRAINT) throws -> ap242.sPRODUCT_OR_FORMATION_OR_DEFINITION? {
	let document = documentUsageConstraint.SOURCE
	return try managedDocument(of: document)
}

/// obtains a unmanaged document file for a given portion of document usage
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
public func documentFile(of documentUsageConstraint: ap242.eDOCUMENT_USAGE_CONSTRAINT) -> ap242.eDOCUMENT_FILE? {
	let document = documentUsageConstraint.SOURCE
	return documentFile(as: document)
}
