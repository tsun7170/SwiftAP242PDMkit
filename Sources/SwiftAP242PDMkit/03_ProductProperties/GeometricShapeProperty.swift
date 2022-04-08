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

/// obtains all shape definition representations in a schema instance
/// - Parameter domain: schema instance
/// - Returns: all shape definition representations found
///
/// # Reference
/// 3.2.1 Geometric Shape Property;
/// 3.2.1.2 shape_definition_representation;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func shapeDefinitionRepresentations(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.eSHAPE_DEFINITION_REPRESENTATION> {
	let instances = domain.entityExtent(type: ap242.eSHAPE_DEFINITION_REPRESENTATION.self)
	return Set(instances)
}

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
public func shape(of productDefinition: ap242.ePRODUCT_DEFINITION?) throws -> ap242.ePRODUCT_DEFINITION_SHAPE? {
	let usedin = Set(SDAI.USEDIN(
		T: productDefinition, 
		ROLE: \ap242.ePRODUCT_DEFINITION_SHAPE.DEFINITION) )
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleProductDefinitionShapes(usedin)
	}
	let shape = usedin.first
	return shape
}


/// obtains the representations product definition shape
/// - Parameter productDefinitionShape: product definition shape
/// - Returns: shape definition representations
/// 
/// # Reference
/// 3.2.1 Geometric Shape Property;
/// 3.2.1.2 shape_definition_representation;
/// 3.2.1.3 shape_representation;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func representations(of productDefinitionShape: ap242.ePRODUCT_DEFINITION_SHAPE?) -> Set<ap242.eSHAPE_DEFINITION_REPRESENTATION> {
	let usedin = SDAI.USEDIN(
		T: productDefinitionShape, 
		ROLE: \ap242.eSHAPE_DEFINITION_REPRESENTATION.DEFINITION) 
	return Set(usedin)
}

/// obtains the shape definition representation of a given shape representation
/// - Parameter shapeRepresentation: shape representation
/// - Throws: multipleShapeDefinitionRepresentations
/// - Returns: shape definition representation
/// 
/// # Reference
/// 3.2.1 Geometric Shape Property;
/// 3.2.1.2 shape_definition_representation;
/// 3.2.1.3 shape_representation;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func shapeDefinition(of shapeRepresentation: ap242.eSHAPE_REPRESENTATION?) throws -> ap242.eSHAPE_DEFINITION_REPRESENTATION? {
	let usedin = Set(SDAI.USEDIN(T: shapeRepresentation, ROLE: \ap242.eSHAPE_DEFINITION_REPRESENTATION.USED_REPRESENTATION))
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleShapeDefinitionRepresentations(usedin)
	}
	let shapedef = usedin.first
	return shapedef
}

/// obtains the product_definition which owns a given shape representation
/// - Parameter shapeRepresentation: shape representation
/// - Throws: multipleShapeDefinitionRepresentations
/// - Returns: product definition owning the given shape representation
/// 
/// # Reference
/// 3.2.1 Geometric Shape Property;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func productDefinition(of shapeRepresentation: ap242.eSHAPE_REPRESENTATION?) throws -> ap242.ePRODUCT_DEFINITION? {
	guard let shapeDefinitionRepresentation = try shapeDefinition(of: shapeRepresentation) else { return nil }
	let productDefinitionShape = shapeDefinitionRepresentation.DEFINITION
	let productDefinition = productDefinitionShape.DEFINITION.super_ePRODUCT_DEFINITION
	return productDefinition	
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
	guard let context = shapeRepresentation.CONTEXT_OF_ITEMS
					.sub_eGEOMETRIC_REPRESENTATION_CONTEXT else {
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
										.compactMap{ $0.sub_eGEOMETRIC_REPRESENTATION_ITEM })
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
public func shapeAspects(of productDefinitionShape: ap242.ePRODUCT_DEFINITION_SHAPE?) -> Set<ap242.eSHAPE_ASPECT> {
	let usedin = SDAI.USEDIN(
		T: productDefinitionShape, 
		ROLE: \ap242.eSHAPE_ASPECT.OF_SHAPE) 
	let aspects = Set( usedin )
	return aspects
}


/// obtains the representations of a portion of product definition shape
/// - Parameter shapeAspect: a portion of product definition shape
/// - Returns: shape definition representations
/// 
/// # Reference
/// 3.2.2 Portions of the Part Shape;
/// 3.2.2.1 shape_aspect;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func representations(of shapeAspect: ap242.eSHAPE_ASPECT?) -> Set<ap242.eSHAPE_DEFINITION_REPRESENTATION> {
	let usedin = SDAI.USEDIN(
		T: shapeAspect, 
		ROLE: \ap242.ePROPERTY_DEFINITION.DEFINITION) 
	let sdreps = usedin.lazy.map{
		SDAI.USEDIN(T: $0, ROLE: \ap242.eSHAPE_DEFINITION_REPRESENTATION.DEFINITION)
	}.joined()
	
	return Set(sdreps)
}



//MARK: - Relating Part Shape

/// obtains all shape_representation_relationship contained in a shcema instance
/// - Parameter domain: schema instance
/// - Returns: all shape_representation_relationship found
/// 
/// # Reference
/// 3.3.1 Relating Part Shape
/// 3.3.1.1 shape_representation_relationship
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func shapeRepresentationRelationships(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.eSHAPE_REPRESENTATION_RELATIONSHIP> {
	let instances = domain.entityExtent(type: ap242.eSHAPE_REPRESENTATION_RELATIONSHIP.self)
	return Set(instances)
}

/// obtains the shape representations related as rep1 to a given rep2 shape representation
/// - Parameter shapeRep2: rep2 shape representation
/// - Returns: shape representation relationships which contain related rep1 shape representations
/// 
/// # Reference
/// 3.3.1 Relating Part Shape
/// 3.3.1.1 shape_representation_relationship
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatedShapeRep1s(to shapeRep2: ap242.eSHAPE_REPRESENTATION?) -> Set<ap242.eSHAPE_REPRESENTATION_RELATIONSHIP> {
	let usedin = SDAI.USEDIN(
		T: shapeRep2, 
		ROLE: \ap242.eSHAPE_REPRESENTATION_RELATIONSHIP.REP_2) 
	let rep1s = Set(usedin)
	return rep1s
}

/// obtains the shape representations related as rep2 to a given rep1 shape representation
/// - Parameter shapeRep1: rep1 shape representation
/// - Returns: shape representation relationships which contain related rep2 shape representations
/// 
/// # Reference
/// 3.3.1 Relating Part Shape
/// 3.3.1.1 shape_representation_relationship
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func relatedShapeRep2s(to shapeRep1: ap242.eSHAPE_REPRESENTATION?) -> Set<ap242.eSHAPE_REPRESENTATION_RELATIONSHIP> {
	let usedin = SDAI.USEDIN(
		T: shapeRep1, 
		ROLE: \ap242.eSHAPE_REPRESENTATION_RELATIONSHIP.REP_1) 
	let rep2s = Set(usedin)
	return rep2s
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
public func definitionalShapeDefinitions(of shapeRepresentation: ap242.eSHAPE_REPRESENTATION?) throws -> ap242.eDOCUMENT_FILE? {
	let usedin = Set(SDAI.USEDIN(
		T: shapeRepresentation, 
		ROLE: \ap242.ePROPERTY_DEFINITION_REPRESENTATION.USED_REPRESENTATION) )
	let externalDefinition = usedin.filter{ $0.DEFINITION.NAME?.asSwiftType == "external definition" }
	guard externalDefinition.count <= 1 else {
		throw PDMkitError.multipleDefinitionalShapes(externalDefinition)
	}
	let docFile = ap242.eDOCUMENT_FILE(externalDefinition.first?.DEFINITION.DEFINITION)
	return docFile
}


