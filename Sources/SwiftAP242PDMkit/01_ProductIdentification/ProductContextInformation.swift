//
//  File.swift
//  
//
//  Created by Yoshida on 2021/08/21.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains all the product contexts associated with a given product master
/// - Parameter productMaster: product master
/// - Returns: associated product contexts
/// 
/// # Reference
/// 1.1.2 Context Information;
/// 1.1.2.3 product_context;
/// 5.1.2 Context Information;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func contexts(of productMaster: ap242.ePRODUCT) -> Set<ap242.ePRODUCT_CONTEXT> {
	let contexts = productMaster.FRAME_OF_REFERENCE
	return contexts.asSwiftType
}


/// obtains an application context associated with a given product context
/// - Parameter productContext: product context
/// - Returns: associated application context
/// 
/// # Reference
/// 1.1.2.2 application_context;
/// 1.1.2.3 product_context;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func applicationContext(of productContext: ap242.ePRODUCT_CONTEXT) -> ap242.eAPPLICATION_CONTEXT {
	let appContext = productContext.FRAME_OF_REFERENCE
	return appContext
}


/// obtains an application context associated with a given product definition context
/// - Parameter productDefinitionContext: product definition context
/// - Returns: associated application context
/// 
/// # Reference
/// 1.1.2.2 application_context;
/// 1.1.2.4 product_definition_context;
/// 1.1.2.5 product_deginition_context_association;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func applicationContext(of productDefinitionContext: ap242.ePRODUCT_DEFINITION_CONTEXT) -> ap242.eAPPLICATION_CONTEXT {
	let appContext = productDefinitionContext.FRAME_OF_REFERENCE
	return appContext
}


/// obtains an application protocol identification optionally associated with a given application context
/// - Parameter applicationContext: application context
/// - Throws: multipleApplicationProtocols
/// - Returns: associated application protocol identification
/// 
/// # Reference
/// 1.1.2.1 application_protocol_definition;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func applicationProtocol(of applicationContext: ap242.eAPPLICATION_CONTEXT) throws -> ap242.eAPPLICATION_PROTOCOL_DEFINITION? {
	if let usedin = SDAI.USEDIN(
			T: applicationContext, 
			ROLE: \ap242.eAPPLICATION_PROTOCOL_DEFINITION.APPLICATION) {
		guard usedin.size == 1 else {
			throw PDMkitError.multipleApplicationProtocols(usedin.asSwiftType)
		}
		let ap = usedin[1]
		return ap
	}
	return nil
}


/// obtains a single primary context associated with a given product definition
/// - Parameter productDefinition: product definition
/// - Returns: associated primary product definition context
/// 
/// # Reference
/// 1.1.2.4 product_definition_context;
/// 5.1.2.2 product_definition_context;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func primaryContext(of productDefinition: ap242.ePRODUCT_DEFINITION) -> ap242.ePRODUCT_DEFINITION_CONTEXT {
	let prim = productDefinition.FRAME_OF_REFERENCE
	return prim
}


/// obtains additional contexts assigned to a given product definition
/// - Parameter productDefinition: product definition
/// - Returns: set of assigned product definition context associations
/// 
/// # Reference
/// 1.1.2.4 product_definition_context;
/// 1.1.2.5 product_deginition_context_association;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func additionalContexts(of productDefinition: ap242.ePRODUCT_DEFINITION) -> Set<ap242.ePRODUCT_DEFINITION_CONTEXT_ASSOCIATION> {
	if let usedin = SDAI.USEDIN(
			T: productDefinition, 
			ROLE: \ap242.ePRODUCT_DEFINITION_CONTEXT_ASSOCIATION.DEFINITION) {
		let contexts = Set(usedin.asSwiftType)
		return contexts
	}
	return []
}

