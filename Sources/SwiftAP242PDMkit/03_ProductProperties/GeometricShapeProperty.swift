//
//  GeometricShapeProperty.swift
//  
//
//  Created by Yoshida on 2021/08/22.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore


/// obtains all shape definition representations in a schema instance (3.2.1.2)
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
///
public func shapeDefinitionRepresentations(
	in domain: SDAIPopulationSchema.SchemaInstance?
) -> Set<apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef>
{
	guard let domain else { return [] }
	let instances = domain.entityExtent(type: apPDM.eSHAPE_DEFINITION_REPRESENTATION.self)
	return Set( instances.map{$0.pRef} )
}

/// obtains the shape of a given product definition (3.2.1.1)
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
///
public func shape(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) throws -> apPDM.ePRODUCT_DEFINITION_SHAPE.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: productDefinition, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_SHAPE.DEFINITION) )
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleProductDefinitionShapes(usedin)
	}
	let shape = usedin.first
	return shape
}


/// obtains the representations product definition shape (3.2.1.2-3)
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
///
public func representations(
	of productDefinitionShape: apPDM.ePRODUCT_DEFINITION_SHAPE.PRef?
) -> Set<apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productDefinitionShape, 
		ROLE: \apPDM.eSHAPE_DEFINITION_REPRESENTATION.DEFINITION) 
	return Set(usedin)
}

/// obtains the shape definition representation of a given shape representation (3.2.1.2-3)
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
///
public func shapeDefinition(
	of shapeRepresentation: apPDM.eSHAPE_REPRESENTATION.PRef?
) throws -> apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef?
{
	let usedin = Set(SDAI.USEDIN(T: shapeRepresentation, ROLE: \apPDM.eSHAPE_DEFINITION_REPRESENTATION.USED_REPRESENTATION))
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleShapeDefinitionRepresentations(usedin)
	}
	let shapedef = usedin.first
	return shapedef
}

/// obtains the product_definition which owns a given shape representation (3.2.1)
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
///
public func productDefinition(
	of shapeRepresentation: apPDM.eSHAPE_REPRESENTATION.PRef?
) throws -> apPDM.ePRODUCT_DEFINITION.PRef?
{
	guard let shapeDefinitionRepresentation = try shapeDefinition(of: shapeRepresentation) else { return nil }
	let productDefinitionShape = shapeDefinitionRepresentation.DEFINITION
	let productDefinition = productDefinitionShape?.DEFINITION?.super_ePRODUCT_DEFINITION
	return productDefinition
}


/// obtains the geometric context of a given shape representation (3.2.1.3-4)
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
///
public func context(
	of shapeRepresentation: apPDM.eSHAPE_REPRESENTATION.PRef
) throws -> apPDM.eGEOMETRIC_REPRESENTATION_CONTEXT.PRef
{
	guard let context = shapeRepresentation.CONTEXT_OF_ITEMS?
					.sub_eGEOMETRIC_REPRESENTATION_CONTEXT else {
		throw PDMkitError.noGeometricRepresentationContext(shapeRepresentation)
	}
	return context.pRef
}


/// obtains the geometric representation items for a given shape representation (3.2.1.3,.5)
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
///
public func geometricItems(
	of shapeRepresentation: apPDM.eSHAPE_REPRESENTATION.PRef
) -> Set<apPDM.eGEOMETRIC_REPRESENTATION_ITEM.PRef>
{
	guard let shapeRepresentation = shapeRepresentation.eval else { return [] }

	let items = Set(shapeRepresentation.ITEMS.lazy
		.compactMap{ $0.sub_eGEOMETRIC_REPRESENTATION_ITEM?.pRef })
	return items
}

//MARK: - portions of the part shape


/// obtains the portions of product definition shape (3.2.2.1)
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
///
public func shapeAspects(
	of productDefinitionShape: apPDM.ePRODUCT_DEFINITION_SHAPE.PRef?
) -> Set<apPDM.eSHAPE_ASPECT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productDefinitionShape, 
		ROLE: \apPDM.eSHAPE_ASPECT.OF_SHAPE) 
	let aspects = Set( usedin )
	return aspects
}


/// obtains the representations of a portion of product definition shape (3.2.2.1)
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
///
public func representations(
	of shapeAspect: apPDM.eSHAPE_ASPECT.PRef?
) -> Set<apPDM.eSHAPE_DEFINITION_REPRESENTATION.PRef>
{
	let usedin = SDAI.USEDIN(
		T: shapeAspect, 
		ROLE: \apPDM.ePROPERTY_DEFINITION.DEFINITION) 
	let sdreps = usedin.lazy.map{
		SDAI.USEDIN(T: $0, ROLE: \apPDM.eSHAPE_DEFINITION_REPRESENTATION.DEFINITION)
	}.joined()
	
	return Set(sdreps)
}



//MARK: - Relating Part Shape

/// obtains all shape_representation_relationship contained in a schema instance (3.3.1.1)
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
///
public func shapeRepresentationRelationships(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.eSHAPE_REPRESENTATION_RELATIONSHIP.PRef>
{
	let instances = domain.entityExtent(type: apPDM.eSHAPE_REPRESENTATION_RELATIONSHIP.self)
	return Set( instances.map{$0.pRef} )
}

/// obtains the shape representations related as rep1 to a given rep2 shape  representation (3.3.1.1)
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
///
public func relatedShapeRep1s(
	to shapeRep2: apPDM.eSHAPE_REPRESENTATION.PRef?
) -> Set<apPDM.eSHAPE_REPRESENTATION_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: shapeRep2, 
		ROLE: \apPDM.eSHAPE_REPRESENTATION_RELATIONSHIP.REP_2) 
	let rep1s = Set(usedin)
	return rep1s
}

/// obtains the shape representations related as rep2 to a given rep1 shape representation (3.3.1.1)
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
///
public func relatedShapeRep2s(
	to shapeRep1: apPDM.eSHAPE_REPRESENTATION.PRef?
) -> Set<apPDM.eSHAPE_REPRESENTATION_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: shapeRep1, 
		ROLE: \apPDM.eSHAPE_REPRESENTATION_RELATIONSHIP.REP_1) 
	let rep2s = Set(usedin)
	return rep2s
}



//MARK: - definitional shape of the part externally defined


/// obtains the external geometric model file containing the definitional shape of the product (3.2.3)
/// - Parameter shapeRepresentation: shape representation of a product
/// - Throws: multipleDefinitionalShapes
/// - Returns: document file for external geometric model
/// 
/// # Note
/// It is recommended that applied_document_reference be used, in general, to relate an external file representing the CAD model to the product_definition of a part identification (see Section 10).
/// 
/// # Reference
/// 3.2.3 Relating Externally Defined Part Shape to an External File
///
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func definitionalShapeDefinitions(
	of shapeRepresentation: apPDM.eSHAPE_REPRESENTATION.PRef?
) throws -> apPDM.eDOCUMENT_FILE.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: shapeRepresentation, 
		ROLE: \apPDM.ePROPERTY_DEFINITION_REPRESENTATION.USED_REPRESENTATION) )
	let externalDefinition = usedin.filter{ $0.DEFINITION?.NAME?.asSwiftType == "external definition" }
	guard externalDefinition.count <= 1 else {
		throw PDMkitError.multipleDefinitionalShapes(externalDefinition)
	}
	let docFile = apPDM.eDOCUMENT_FILE(externalDefinition.first?.DEFINITION?.DEFINITION)
	return docFile?.pRef
}


