//
//  ProductContextInformation.swift
//  
//
//  Created by Yoshida on 2021/08/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains all the product contexts associated with a given product master (1.1.2.3)(5.1.2)
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
///
public func contexts(
	of productMaster: apPDM.ePRODUCT.PRef
) -> Set<apPDM.ePRODUCT_CONTEXT.PRef>
{
	let contexts = productMaster.FRAME_OF_REFERENCE
	return contexts?.asSwiftType ?? []
}


/// obtains an application context associated with a given product context (1.1.2.2-3)
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
///
public func applicationContext(
	of productContext: apPDM.ePRODUCT_CONTEXT.PRef
) -> apPDM.eAPPLICATION_CONTEXT.PRef
{
	let appContext = productContext.FRAME_OF_REFERENCE
	return SDAI.UNWRAP(appContext)
}


/// obtains an application context associated with a given product definition context (1.1.2.2-5)
/// - Parameter productDefinitionContext: product definition context
/// - Returns: associated application context
/// 
/// # Reference
/// 1.1.2.2 application_context;
/// 1.1.2.4 product_definition_context;
/// 1.1.2.5 product_definition_context_association;
///
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func applicationContext(
	of productDefinitionContext: apPDM.ePRODUCT_DEFINITION_CONTEXT.PRef
) -> apPDM.eAPPLICATION_CONTEXT.PRef
{
	let appContext = productDefinitionContext.FRAME_OF_REFERENCE
	return SDAI.UNWRAP(appContext)
}


/// obtains an application protocol identification optionally associated with a given application context (1.1.2.1)
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
///
public func applicationProtocol(
	of applicationContext: apPDM.eAPPLICATION_CONTEXT.PRef?
) throws -> apPDM.eAPPLICATION_PROTOCOL_DEFINITION.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: applicationContext, 
		ROLE: \apPDM.eAPPLICATION_PROTOCOL_DEFINITION.APPLICATION)) 
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleApplicationProtocols(usedin)
	}
	let ap = usedin.first
	return ap
}


/// obtains a single primary context associated with a given product definition (1.1.2.4)(5.1.2.2)
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
///
public func primaryContext(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef
) -> apPDM.ePRODUCT_DEFINITION_CONTEXT.PRef
{
	let prim = productDefinition.FRAME_OF_REFERENCE
	return SDAI.UNWRAP(prim)
}


/// obtains additional contexts assigned to a given product definition (1.1.2.4-5)
/// - Parameter productDefinition: product definition
/// - Returns: set of assigned product definition context associations
/// 
/// # Reference
/// 1.1.2.4 product_definition_context;
/// 1.1.2.5 product_definition_context_association;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func additionalContexts(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION_CONTEXT_ASSOCIATION.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productDefinition, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_CONTEXT_ASSOCIATION.DEFINITION)
	let contexts = Set(usedin)
	return contexts
}

