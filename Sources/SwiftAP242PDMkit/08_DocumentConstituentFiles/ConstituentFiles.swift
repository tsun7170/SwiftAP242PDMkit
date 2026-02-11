//
//  ConstituentFiles.swift
//  
//
//  Created by Yoshida on 2021/08/26.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains the constituent external files associated with a given document product definition (8.1.1)
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
///
public func externalFiles(
	of documentProductDefinition: apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.PRef
) -> Set<apPDM.eDOCUMENT_FILE.PRef>
{
	guard let docFiles = documentProductDefinition.DOCUMENTATION_IDS?.lazy
		.compactMap({ apPDM.eDOCUMENT_FILE.convert(sibling: $0)?.pRef })
	else { return Set() }
	return Set(docFiles)
}
