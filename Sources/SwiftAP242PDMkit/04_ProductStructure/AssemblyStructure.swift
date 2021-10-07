//
//  AssemblyStructure.swift
//  
//
//  Created by Yoshida on 2021/08/22.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


/// obtains parent assemblies of a given product definition
/// - Parameter productDefinition: product definition
/// - Returns: parent assemblies
/// 
/// # Reference
/// 4.1 Explicit Assembly Bill Of Material;
/// 4.1.1.1 assembly_component_usage;
/// 4.1.1.2 next_assembly_usage_occurrence;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func parentAssemblies(of productDefinition: ap242.ePRODUCT_DEFINITION) -> Set<ap242.eNEXT_ASSEMBLY_USAGE_OCCURRENCE> {
	if let usedin = SDAI.USEDIN(
			T: productDefinition, 
			ROLE: \ap242.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.RELATED_PRODUCT_DEFINITION) {
		return Set(usedin)
	}
	return []
}

/// obtains direct sub-assembly components of a given assenbly product definition
/// - Parameter productDefinition: assembly product definition
/// - Returns: sub-assemblies
/// 
/// # Reference
/// 4.1 Explicit Assembly Bill Of Material;
/// 4.1.1.1 assembly_component_usage;
/// 4.1.1.2 next_assembly_usage_occurrence;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func subComponents(of productDefinition: ap242.ePRODUCT_DEFINITION) -> Set<ap242.eNEXT_ASSEMBLY_USAGE_OCCURRENCE> {
	if let usedin = SDAI.USEDIN(
			T: productDefinition, 
			ROLE: \ap242.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.RELATING_PRODUCT_DEFINITION) {
		return Set(usedin)
	}
	return []
}

/// obtains all top level assemblies contained in a given schema instance
/// - Parameter domain: schema instance
/// - Returns: top level assembly product definitions
/// 
/// # Reference
/// 4.1 Explicit Assembly Bill Of Material;
/// 4.1.1.1 assembly_component_usage;
/// 4.1.1.2 next_assembly_usage_occurrence;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func topLevelProducts(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.ePRODUCT_DEFINITION> {
	let instances = domain.entityExtent(type: ap242.ePRODUCT_DEFINITION.self)
	let toplevels = instances.filter { parentAssemblies(of: $0).isEmpty }
	return Set(toplevels)
}

//MARK: - Promissory Component Usage


/// obtains the higher-level assemblies that promissory using a given product
/// - Parameter productDefinition: product definition
/// - Returns: higher-level assemblies that promissory using the product
/// 
/// # Reference
/// 4.1.4 Promissory Component Usage;
/// 4.1.4.1 promissory_usage_occurrence; 
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func primissoryUsingAssemblies(of productDefinition: ap242.ePRODUCT_DEFINITION) -> Set<ap242.ePROMISSORY_USAGE_OCCURRENCE> {
	if let usedin = SDAI.USEDIN(
			T: productDefinition, 
			ROLE: \ap242.ePROMISSORY_USAGE_OCCURRENCE.RELATED_PRODUCT_DEFINITION) {
		return Set(usedin)
	}
	return []
}

/// obtains all the promissory usages of a given assembly product
/// - Parameter productDefinition: assembly product
/// - Returns: promissory usages
/// 
/// # Reference
/// 4.1.4 Promissory Component Usage;
/// 4.1.4.1 promissory_usage_occurrence; 
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func promissoryUsedComponents(of productDefinition: ap242.ePRODUCT_DEFINITION) -> Set<ap242.ePROMISSORY_USAGE_OCCURRENCE> {
	if let usedin = SDAI.USEDIN(
			T: productDefinition, 
			ROLE: \ap242.ePROMISSORY_USAGE_OCCURRENCE.RELATING_PRODUCT_DEFINITION) {
		return Set(usedin)
	}
	return []
}

//MARK: - Multi-Level Assembly Digital Mock Up



/// obtains all specified higher usages associated with a given product definition
/// - Parameter productDefinition: product definition
/// - Returns: specified higher usages
/// 
/// # Reference
/// 4.2 Multi-Level Assembly Digital Mock Up;
/// 4.2.1.1 specified_higer_usage_occurrence;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func specificHigherUsages(of productDefinition: ap242.ePRODUCT_DEFINITION) -> Set<ap242.eSPECIFIED_HIGHER_USAGE_OCCURRENCE> {
	if let usedin = SDAI.USEDIN(
			T: productDefinition, 
			ROLE: \ap242.eSPECIFIED_HIGHER_USAGE_OCCURRENCE.RELATED_PRODUCT_DEFINITION) {
		return Set(usedin)
	}
	return []
}

/// obtains all specified higher usages under a given assembly product
/// - Parameter higherLevelAssembly: assembly product
/// - Returns: specified higher usages under given assembly
/// 
/// # Reference
/// 4.2 Multi-Level Assembly Digital Mock Up;
/// 4.2.1.1 specified_higer_usage_occurrence;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func specificUseOccurences(within higherLevelAssembly: ap242.ePRODUCT_DEFINITION) -> Set<ap242.eSPECIFIED_HIGHER_USAGE_OCCURRENCE> {
	if let usedin = SDAI.USEDIN(
			T: higherLevelAssembly, 
			ROLE: \ap242.eSPECIFIED_HIGHER_USAGE_OCCURRENCE.RELATING_PRODUCT_DEFINITION) {
		return Set(usedin)
	}
	return []
}

/// obtains all specified higher usages associated with a given component usage
/// - Parameter componentUsage: component usage
/// - Returns: specified higher usages
/// 
/// # Reference
/// 4.2 Multi-Level Assembly Digital Mock Up;
/// 4.2.1.1 specified_higer_usage_occurrence;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func specificUsages(for componentUsage: ap242.eNEXT_ASSEMBLY_USAGE_OCCURRENCE) -> Set<ap242.eSPECIFIED_HIGHER_USAGE_OCCURRENCE> {
	if let usedin = SDAI.USEDIN(
			T: componentUsage, 
			ROLE: \ap242.eSPECIFIED_HIGHER_USAGE_OCCURRENCE.NEXT_USAGE) {
		return Set(usedin)
	}
	return []
}


//MARK: - Context Dependent Shape Representation


/// obtains the geometric shape transformation relationship of component and its assembly
/// - Parameter componentUsage: compoment usage
/// - Throws: multipleProductDefinitionShapes,multipleContextDependentShapeRepresentations
/// - Returns: geometry transformation relationship
/// 
/// # Reference
/// 4.4 Relating Part Shape Properties to Product Structure;
/// 4.4.2 Impllicit Relationships Between Assembly Components;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func assemblyComponentTransformationRelationship(of componentUsage: ap242.eNEXT_ASSEMBLY_USAGE_OCCURRENCE) throws -> ap242.eCONTEXT_DEPENDENT_SHAPE_REPRESENTATION? {
	if let usedin = SDAI.USEDIN(
			T: componentUsage, 
			ROLE: \ap242.ePRODUCT_DEFINITION_SHAPE.DEFINITION) {
		guard usedin.size <= 1 else {
			throw PDMkitError.multipleProductDefinitionShapes(usedin.asSwiftType)
		}
		if let pdShape = usedin[1] {
			if let usedin = SDAI.USEDIN(
					T: pdShape, 
					ROLE: \ap242.eCONTEXT_DEPENDENT_SHAPE_REPRESENTATION.REPRESENTED_PRODUCT_RELATION) {
				guard usedin.size <= 1 else {
					throw PDMkitError.multipleContextDependentShapeRepresentations(usedin.asSwiftType)
				}
				let cdShapeRep = usedin[1]
				return cdShapeRep
			}
		}
	}
	return nil
}

/// obtains the as assembled specific shape of a given component usage
/// - Parameter componentUsage: component usage
/// - Throws: multipleProductDefinitionShapes,multipleShapeDefinitionRepresentations
/// - Returns: assembly specific shape of a component
/// 
/// # Reference
/// 4.4 Relating Part Shape Properties to Product Structure;
/// 4.4.2 Impllicit Relationships Between Assembly Components;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func asAssembledShape(of componentUsage: ap242.eNEXT_ASSEMBLY_USAGE_OCCURRENCE) throws -> ap242.eSHAPE_REPRESENTATION? {
	if let usedin = SDAI.USEDIN(
			T: componentUsage, 
			ROLE: \ap242.ePRODUCT_DEFINITION_SHAPE.DEFINITION) {
		guard usedin.size <= 1 else {
			throw PDMkitError.multipleProductDefinitionShapes(usedin.asSwiftType)
		}
		if let pdShape = usedin[1] {
			if let usedin = SDAI.USEDIN(
					T: pdShape, 
					ROLE: \ap242.eSHAPE_DEFINITION_REPRESENTATION.DEFINITION) {
				guard usedin.size <= 1 else {
					throw PDMkitError.multipleShapeDefinitionRepresentations(usedin.asSwiftType)
				}
				let shapeRep = usedin[1]?.USED_REPRESENTATION
				return shapeRep
			}
		}
	}
	return nil
}


/// obtains the explicit shape representation of a component usage
/// - Parameter componentUsage: component usage
/// - Throws: multipleProductDefinitionShapes,multipleShapeDefinitionRepresentations,multipleMappedItems
/// - Returns: mapped shape representation
/// 
/// # Reference
/// 4.4 Relating Part Shape Properties to Product Structure;
/// 4.4.1 Explicit Representation of Complete Assembly Geometry
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func explicitShape(of componentUsage: ap242.eNEXT_ASSEMBLY_USAGE_OCCURRENCE) throws -> ap242.eMAPPED_ITEM? {
	if let shapeRep = try asAssembledShape(of: componentUsage) {
		let mappedItems = shapeRep.ITEMS.compactMap{ ap242.eMAPPED_ITEM.cast(from: $0) }
		guard mappedItems.count <= 1 else {
			throw PDMkitError.multipleMappedItems(mappedItems)
		}
		return mappedItems.first
	}
	return nil
}

//MARK: - Alternate Parts


/// obtains alternate parts of a given part product master
/// - Parameter primaryBaseProductMaster: part product master
/// - Returns: alternate parts
/// 
/// # Reference
/// 4.5.1 Alternate Parts;
/// 4.5.1.1 alternate_product_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func alternateProducts(for primaryBaseProductMaster: ap242.ePRODUCT) -> Set<ap242.eALTERNATE_PRODUCT_RELATIONSHIP> {
	if let usedin = SDAI.USEDIN(
			T: primaryBaseProductMaster, 
			ROLE: \ap242.eALTERNATE_PRODUCT_RELATIONSHIP.BASE) {
		return Set(usedin)
	}
	return []
}

//MARK: - Substitute Components in an Assembly


/// obtains substitute components for a given component usage
/// - Parameter primaryBaseComponentUsage: component usage
/// - Returns: substitute component usages
/// 
/// # Reference
/// 4.5.2 Substitute Components in an Assembly;
/// 4.5.2.1 assembly_component_usage_substitute;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func substituteComponents(for primaryBaseComponentUsage: ap242.eASSEMBLY_COMPONENT_USAGE) -> Set<ap242.eASSEMBLY_COMPONENT_USAGE_SUBSTITUTE> {
	if let usedin = SDAI.USEDIN(
			T: primaryBaseComponentUsage, 
			ROLE: \ap242.eASSEMBLY_COMPONENT_USAGE_SUBSTITUTE.BASE) {
		return Set(usedin)
	}
	return []
}

//MARK: - Make From Relationships



/// obtains make-from source parts of a given resultant part
/// - Parameter resultantProduct: resultant part definition
/// - Returns: make-from relationships
/// 
/// # Reference
/// 4.5.3 Make From Relationships;
/// 4.5.3.1 make_from_usage_option;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func makeFroms(of resultantProduct: ap242.ePRODUCT_DEFINITION) -> Set<ap242.eMAKE_FROM_USAGE_OPTION> {
	if let usedin = SDAI.USEDIN(
			T: resultantProduct, 
			ROLE: \ap242.eMAKE_FROM_USAGE_OPTION.RELATING_PRODUCT_DEFINITION) {
		return Set(usedin)
	}	
	return []
}

//MARK: - Supplied Part Identification


/// obtains vender part identifications for a given internal part
/// - Parameter internalPartVersion: internal part version
/// - Returns: internal part/vender part relationships
/// 
/// # Reference
/// 4.5.4 Supplied Part Identification;
/// 4.5.4.1 product_definition_formation_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func venderPartIdentifications(for internalPartVersion: ap242.ePRODUCT_DEFINITION_FORMATION) -> Set<ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP> {
	if let usedin = SDAI.USEDIN(
			T: internalPartVersion, 
			ROLE: \ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.RELATING_PRODUCT_DEFINITION_FORMATION) {
		let suppliedItems = usedin.filter{ $0.NAME == "supplied item" } 
		return Set(suppliedItems)
	}
	return []
}

/// obtains internal part identifications for a given vender part
/// - Parameter venderPartVersion: vender part version
/// - Returns: internal part/vender part relationships
/// 
/// # Reference
/// 4.5.4 Supplied Part Identification;
/// 4.5.4.1 product_definition_formation_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func internalPartIdentifications(for venderPartVersion: ap242.ePRODUCT_DEFINITION_FORMATION) -> Set<ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP> {
	if let usedin = SDAI.USEDIN(
			T: venderPartVersion, 
			ROLE: \ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.RELATED_PRODUCT_DEFINITION_FORMATION) {
		let suppliedItems = usedin.filter{ $0.NAME == "supplied item" } 
		return Set(suppliedItems)
	}
	return []
}

//MARK: - Version History Relationship


/// obtains successor versioons of a given product version
/// - Parameter productVersions: product version
/// - Returns: successor product versions
/// 
/// # Reference
/// 4.5.5 Version History Relationships;
/// 4.5.5.1 product_definition_formation_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func successorVersions(of productVersion: ap242.ePRODUCT_DEFINITION_FORMATION) -> Set<ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP> {
	if let usedin = SDAI.USEDIN(
			T: productVersion, 
			ROLE: \ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.RELATING_PRODUCT_DEFINITION_FORMATION) {
		let successors = usedin.filter{ $0.NAME == "sequence" || $0.NAME == "hierarchy" } 
		return Set(successors)
	}
	return []
}

/// obtains the preceding version of a given product version
/// - Parameter productVersion: product version
/// - Throws: multiplePrecedingVersions
/// - Returns: preceding part version
/// 
/// # Reference
/// 4.5.5 Version History Relationships;
/// 4.5.5.1 product_definition_formation_relationship;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func precedingVersion(of productVersion: ap242.ePRODUCT_DEFINITION_FORMATION) throws -> ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP? {
	if let usedin = SDAI.USEDIN(
			T: productVersion, 
			ROLE: \ap242.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.RELATED_PRODUCT_DEFINITION_FORMATION) {
		let precedings = usedin.filter{ $0.NAME == "sequence" || $0.NAME == "hierarchy" } 
		guard precedings.count <= 1 else {
			throw PDMkitError.multiplePrecedingVersions(precedings)
		}
		return precedings.first
	}
	return nil
}


