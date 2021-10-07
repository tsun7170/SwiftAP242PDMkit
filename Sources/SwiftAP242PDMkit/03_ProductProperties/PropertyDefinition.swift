//
//  PropertyDefinition.swift
//  
//
//  Created by Yoshida on 2021/08/22.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains properties associated with a given product definition
/// - Parameter productDefinition: product definition
/// - Returns: all associated properties
/// 
/// # Reference
/// 3.1.1 Properties Associated with Product Data;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func properties(of productDefinition: ap242.ePRODUCT_DEFINITION) -> Set<ap242.ePROPERTY_DEFINITION> {
	if let usedin = SDAI.USEDIN(
			T: productDefinition, 
			ROLE: \ap242.ePROPERTY_DEFINITION.DEFINITION) {
		return Set(usedin)
	}
	return []
}


/// obtains properties associated with a given document file
/// - Parameter documentFile: document file
/// - Returns: all associated properties
/// 
/// # Reference
/// 9 Document and File Properties;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func properties(of documentFile: ap242.eDOCUMENT_FILE) -> Set<ap242.ePROPERTY_DEFINITION> {
	if let usedin = SDAI.USEDIN(
			T: documentFile, 
			ROLE: \ap242.ePROPERTY_DEFINITION.DEFINITION) {
		return Set(usedin)
	}
	return []
}


/// obtains the representation associated with a given property
/// - Parameter propertyDefinition: property
/// - Throws: multiplePropertyRepresentations
/// - Returns: associated representation
/// 
/// # Reference
/// 3.1.1.2 property_definition_representation;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func representation(of propertyDefinition: ap242.ePROPERTY_DEFINITION) throws -> ap242.eREPRESENTATION? {
	if let usedin = SDAI.USEDIN(
			T: propertyDefinition, 
			ROLE: \ap242.ePROPERTY_DEFINITION_REPRESENTATION.DEFINITION) {
		guard usedin.size <= 1 else {
			throw PDMkitError.multiplePropertyRepresentations(usedin.asSwiftType)
		}
		let rep = usedin[1]?.USED_REPRESENTATION
		return rep
	}
	return nil
}


/// obtains the context of interpretation for the values of a given representation
/// - Parameter representation: representation
/// - Returns: context information
/// 
/// # Reference
/// 3.1.1.3 representation;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func context(of representation: ap242.eREPRESENTATION) -> ap242.eREPRESENTATION_CONTEXT {
	let context = representation.CONTEXT_OF_ITEMS
	return context
}


/// obtains the values in a given representation
/// - Parameter representation: representation
/// - Returns: values of a representation
/// 
/// # Reference
/// 3.1.1.3 representation;
/// 9.1.3 representation;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func values(of representation: ap242.eREPRESENTATION) -> Set<ap242.eREPRESENTATION_ITEM> {
	let vals = representation.ITEMS
	return vals.asSwiftType
}

