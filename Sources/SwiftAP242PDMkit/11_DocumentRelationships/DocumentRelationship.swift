//
//  DocumentRelationship.swift
//  
//
//  Created by Yoshida on 2021/08/26.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains related documents for a given document
/// - Parameter document: document
/// - Returns: related documents
/// 
/// # Reference
/// 11.3 Relationships between external files;
/// 11.3.1 document_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatedDocuments(of document: ap242.eDOCUMENT?) -> Set<ap242.eDOCUMENT_RELATIONSHIP> {
	let usedin = SDAI.USEDIN(
		T: document, 
		ROLE: \ap242.eDOCUMENT_RELATIONSHIP.RELATING_DOCUMENT) 
	return Set(usedin)
}

/// obtains relating documents for a gicen document
/// - Parameter document: document
/// - Returns: relating documents
/// 
/// # Reference
/// 11.3 Relationships between external files;
/// 11.3.1 document_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatingDocuments(of document: ap242.eDOCUMENT?) -> Set<ap242.eDOCUMENT_RELATIONSHIP> {
	let usedin = SDAI.USEDIN(
		T: document, 
		ROLE: \ap242.eDOCUMENT_RELATIONSHIP.RELATED_DOCUMENT)
	return Set(usedin)
}

