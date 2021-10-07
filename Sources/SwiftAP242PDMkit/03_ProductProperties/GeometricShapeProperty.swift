//
//  GeometricShapeProperty.swift
//  
//
//  Created by Yoshida on 2021/08/22.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains the shape of a given product definition
/// - Parameter productDefinition: product definition
/// - Throws: multipleProductDefinitionShapes
/// - Returns: shape of product
/// 
/// # Reference
/// 3.2.1 Geometric Shape Property;
/// 3.2.1.1 product_definition_shape;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func shape(of productDefinition: ap242.ePRODUCT_DEFINITION) throws -> ap242.ePRODUCT_DEFINITION_SHAPE? {
	if let usedin = SDAI.USEDIN(
			T: productDefinition, 
			ROLE: \ap242.ePRODUCT_DEFINITION_SHAPE.DEFINITION) {
		guard usedin.size <= 1 else {
			throw PDMkitError.multipleProductDefinitionShapes(usedin.asSwiftType)
		}
		let shape = usedin[1]
		return shape
	}
	return nil
}


/// obtains the representations product definition shape
/// - Parameter productDefinitionShape: product definition shape
/// - Returns: shape representations
/// 
/// # Reference
/// 3.2.1 Geometric Shape Property;
/// 3.2.1.2 shape_definition_representation;
/// 3.2.1.3 shape_representation;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func representations(of productDefinitionShape: ap242.ePRODUCT_DEFINITION_SHAPE) -> Set<ap242.eSHAPE_REPRESENTATION> {
	if let usedin = SDAI.USEDIN(
			T: productDefinitionShape, 
			ROLE: \ap242.eSHAPE_DEFINITION_REPRESENTATION.DEFINITION) {
		let reps = Set(usedin.lazy.map{ $0.USED_REPRESENTATION })
		return reps
	}
	return []
}


/// obtains the geometric context of a given shape representation
/// - Parameter shapeRepresentation: shape representation
/// - Throws: noGeometricRepresentationContext
/// - Returns: geometric context
/// 
/// # Reference
/// 3.2.1 Geometric Shape Property;
/// 3.2.1.3 shape_representation;
/// 3.2.1.4 geometric_representation_context;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func context(of shapeRepresentation: ap242.eSHAPE_REPRESENTATION) throws -> ap242.eGEOMETRIC_REPRESENTATION_CONTEXT {
	guard let context = ap242.eGEOMETRIC_REPRESENTATION_CONTEXT.cast(from: shapeRepresentation.CONTEXT_OF_ITEMS) else {
		throw PDMkitError.noGeometricRepresentationContext(shapeRepresentation)
	}
	return context
}


/// obtains the geometric representation items for a given shape representation
/// - Parameter shapeRepresentation: shape representation
/// - Returns: geometric representation items
/// 
/// # Reference
/// 3.2.1 Geometric Shape Property;
/// 3.2.1.3 shape_representation;
/// 3.2.1.5 geometric_representation_item;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func geometricItems(of shapeRepresentation: ap242.eSHAPE_REPRESENTATION) -> Set<ap242.eGEOMETRIC_REPRESENTATION_ITEM> {
	let items = Set(shapeRepresentation.ITEMS.lazy
										.compactMap{ ap242.eGEOMETRIC_REPRESENTATION_ITEM.cast(from: $0) })
	return items
}

//MARK: - portions of the part shape


/// obtains the portions of product definition shape 
/// - Parameter productDefinitionShape: product definition shape
/// - Returns: portions of a product definition shape
/// 
/// # Reference
/// 3.2.2 Portions of the Part Shape;
/// 3.2.2.1 shape_aspect;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func shapeAspects(of productDefinitionShape: ap242.ePRODUCT_DEFINITION_SHAPE) -> Set<ap242.eSHAPE_ASPECT> {
	if let usedin = SDAI.USEDIN(
			T: productDefinitionShape, 
			ROLE: \ap242.eSHAPE_ASPECT.OF_SHAPE) {
		let aspects = Set( usedin )
		return aspects
	}
	return []
}


/// obtains the representations of a portion of product definition shape
/// - Parameter shapeAspect: a portion of product definition shape
/// - Returns: shape representations
/// 
/// # Reference
/// 3.2.2 Portions of the Part Shape;
/// 3.2.2.1 shape_aspect;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func representations(of shapeAspect: ap242.eSHAPE_ASPECT) -> Set<ap242.eSHAPE_REPRESENTATION> {
	if let usedin = SDAI.USEDIN(
			T: shapeAspect, 
			ROLE: \ap242.ePROPERTY_DEFINITION.DEFINITION) {
		let sdreps = usedin.lazy.compactMap{
			SDAI.USEDIN(T: $0, ROLE: \ap242.eSHAPE_DEFINITION_REPRESENTATION.DEFINITION)
		}.joined()
		
		let shapeReps = Set(sdreps.map{ $0.USED_REPRESENTATION })
		return shapeReps
	}
	return []
}



//MARK: - Relating Part Shape


/// obtains the shape representations related as rep1 to a given rep2 shape representation
/// - Parameter shapeRep2: rep2 shape representation
/// - Returns: shape representation relationships which contain related rep1 shape representaions
/// 
/// # Reference
/// 3.3.1 Relating Part Shape
/// 3.3.1.1 shape_representation_relationship
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatedShapeRep1s(to shapeRep2: ap242.eSHAPE_REPRESENTATION) -> Set<ap242.eSHAPE_REPRESENTATION_RELATIONSHIP> {
	if let usedin = SDAI.USEDIN(
			T: shapeRep2, 
			ROLE: \ap242.eSHAPE_REPRESENTATION_RELATIONSHIP.REP_2) {
		let rep1s = Set(usedin)
		return rep1s
	}
	return []
}

/// obtains the shape representations related as rep2 to a given rep1 shape representation
/// - Parameter shapeRep1: rep1 shape representation
/// - Returns: shape representation relationships which contain related rep2 shape representaions
/// 
/// # Reference
/// 3.3.1 Relating Part Shape
/// 3.3.1.1 shape_representation_relationship
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatedShapeRep2s(to shapeRep1: ap242.eSHAPE_REPRESENTATION) -> Set<ap242.eSHAPE_REPRESENTATION_RELATIONSHIP> {
	if let usedin = SDAI.USEDIN(
			T: shapeRep1, 
			ROLE: \ap242.eSHAPE_REPRESENTATION_RELATIONSHIP.REP_1) {
		let rep2s = Set(usedin)
		return rep2s
	}
	return []
}



//MARK: - definitional shape of the part externally defined


/// obtains the external geometric model file containing the definitional shape of the product
/// - Parameter shapeRepresentation: shape representation of a product
/// - Throws: multipleDefinitionalShapes
/// - Returns: document file for external geometric model
/// 
/// # Note
/// It is recommended that applied_document_reference be used, in general, to relate an external file representing the CAD model to the product_definition of a part identification (see Section 10).
/// 
/// # Reference
/// 3.2.3 Ralating Externally Defined Part Shape to an External File
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func definitionalShapeDefinitions(of shapeRepresentation: ap242.eSHAPE_REPRESENTATION) throws -> ap242.eDOCUMENT_FILE? {
	if let usedin = SDAI.USEDIN(
			T: shapeRepresentation, 
			ROLE: \ap242.ePROPERTY_DEFINITION_REPRESENTATION.USED_REPRESENTATION) {
		let extDef = usedin.filter{ $0.DEFINITION.NAME?.asSwiftType == "external definition" }
		guard extDef.count <= 1 else {
			throw PDMkitError.multipleDefinitionalShapes(extDef)
		}
		let docFile = ap242.eDOCUMENT_FILE(extDef.first?.DEFINITION.DEFINITION)
		return docFile
	}
	return nil
}


