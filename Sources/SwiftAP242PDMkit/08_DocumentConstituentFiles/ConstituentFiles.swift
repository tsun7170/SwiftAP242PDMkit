//
//  File.swift
//  
//
//  Created by Yoshida on 2021/08/26.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains the constituent external files associated with a given document product definition
/// - Parameter documentProductDefinition: document product definition
/// - Returns: external document files
/// 
/// # Reference
/// 8 Relationship Between Documents and Constituent Files;
/// 8.1 Product Definition with associated documents;
/// 8.1.1 product_definition_with_associated_documents;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func externalFiles(of documentProductDefinition: ap242.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS) -> Set<ap242.eDOCUMENT_FILE> {
	let docFiles = documentProductDefinition.DOCUMENTATION_IDS
		.lazy
		.compactMap{ ap242.eDOCUMENT_FILE.cast(from: $0) }
	return Set(docFiles)
}
