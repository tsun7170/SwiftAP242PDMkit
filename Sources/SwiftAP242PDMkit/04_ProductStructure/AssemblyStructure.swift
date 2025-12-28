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
///
public func parentAssemblies(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productDefinition, 
		ROLE: \apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.RELATED_PRODUCT_DEFINITION) 
	return Set(usedin)
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
///
public func subComponents(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productDefinition, 
		ROLE: \apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.RELATING_PRODUCT_DEFINITION) 
	return Set(usedin)
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
///
public func topLevelProducts(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.ePRODUCT_DEFINITION.PRef>
{
	let instances = domain.entityExtent(type: apPDM.ePRODUCT_DEFINITION.self)
	let toplevels = instances.filter { parentAssemblies(of: $0.pRef).isEmpty }
	return Set( toplevels.map{$0.pRef} )
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
///
public func promissoryUsingAssemblies(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.ePROMISSORY_USAGE_OCCURRENCE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productDefinition, 
		ROLE: \apPDM.ePROMISSORY_USAGE_OCCURRENCE.RELATED_PRODUCT_DEFINITION)
	return Set(usedin)
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
///
public func promissoryUsedComponents(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.ePROMISSORY_USAGE_OCCURRENCE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productDefinition, 
		ROLE: \apPDM.ePROMISSORY_USAGE_OCCURRENCE.RELATING_PRODUCT_DEFINITION) 
	return Set(usedin)
}


//MARK: - Multi-Level Assembly Digital Mock Up

/// obtains all specified higher usages associated with a given product definition
/// - Parameter productDefinition: product definition
/// - Returns: specified higher usages
/// 
/// # Reference
/// 4.2 Multi-Level Assembly Digital Mock Up;
/// 4.2.1.1 specified_higher_usage_occurrence;
///
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func specificHigherUsages(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.eSPECIFIED_HIGHER_USAGE_OCCURRENCE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productDefinition, 
		ROLE: \apPDM.eSPECIFIED_HIGHER_USAGE_OCCURRENCE.RELATED_PRODUCT_DEFINITION)
	return Set(usedin)
}

/// obtains all specified higher usages under a given assembly product
/// - Parameter higherLevelAssembly: assembly product
/// - Returns: specified higher usages under given assembly
/// 
/// # Reference
/// 4.2 Multi-Level Assembly Digital Mock Up;
/// 4.2.1.1 specified_higher_usage_occurrence;
///
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func specificUseOccurrences(
	within higherLevelAssembly: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.eSPECIFIED_HIGHER_USAGE_OCCURRENCE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: higherLevelAssembly, 
		ROLE: \apPDM.eSPECIFIED_HIGHER_USAGE_OCCURRENCE.RELATING_PRODUCT_DEFINITION) 
	return Set(usedin)
}

/// obtains all specified higher usages associated with a given component usage
/// - Parameter componentUsage: component usage
/// - Returns: specified higher usages
/// 
/// # Reference
/// 4.2 Multi-Level Assembly Digital Mock Up;
/// 4.2.1.1 specified_higher_usage_occurrence;
///
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func specificUsages(
	for componentUsage: apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef?
) -> Set<apPDM.eSPECIFIED_HIGHER_USAGE_OCCURRENCE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: componentUsage, 
		ROLE: \apPDM.eSPECIFIED_HIGHER_USAGE_OCCURRENCE.NEXT_USAGE) 
	return Set(usedin)
}


//MARK: - Context Dependent Shape Representation

/// obtains the geometric shape transformation relationship of component and its assembly
/// - Parameter componentUsage: component usage
/// - Throws: multipleProductDefinitionShapes,multipleContextDependentShapeRepresentations
/// - Returns: geometry transformation relationship
/// 
/// # Reference
/// 4.4 Relating Part Shape Properties to Product Structure;
/// 4.4.2 Implicit Relationships Between Assembly Components;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func assemblyComponentTransformationRelationship(
	of componentUsage: apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef?
) throws -> apPDM.eCONTEXT_DEPENDENT_SHAPE_REPRESENTATION.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: componentUsage, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_SHAPE.DEFINITION) )
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleProductDefinitionShapes(usedin)
	}
	if let pdShape = usedin.first {
		let usedin = Set(SDAI.USEDIN(
			T: pdShape, 
			ROLE: \apPDM.eCONTEXT_DEPENDENT_SHAPE_REPRESENTATION.REPRESENTED_PRODUCT_RELATION) )
		guard usedin.count <= 1 else {
			throw PDMkitError.multipleContextDependentShapeRepresentations(usedin)
		}
		let cdShapeRep = usedin.first
		return cdShapeRep
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
/// 4.4.2 Implicit Relationships Between Assembly Components;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func asAssembledShape(
	of componentUsage: apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef?
) throws -> apPDM.eSHAPE_REPRESENTATION.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: componentUsage, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_SHAPE.DEFINITION) )
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleProductDefinitionShapes(usedin)
	}
	if let pdShape = usedin.first {
		let usedin = Set(SDAI.USEDIN(
			T: pdShape, 
			ROLE: \apPDM.eSHAPE_DEFINITION_REPRESENTATION.DEFINITION) )
		guard usedin.count <= 1 else {
			throw PDMkitError.multipleShapeDefinitionRepresentations(usedin)
		}
		let shapeRep = usedin.first?.USED_REPRESENTATION
		return shapeRep
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
///
public func explicitShape(
	of componentUsage: apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef?
) throws -> apPDM.eMAPPED_ITEM.PRef?
{
	if let shapeRep = try asAssembledShape(of: componentUsage),
		 let items = shapeRep.ITEMS
	{
		let mappedItems = Set(items.lazy.compactMap{ apPDM.eMAPPED_ITEM.convert(sibling: $0)?.pRef })
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
///
public func alternateProducts(
	for primaryBaseProductMaster: apPDM.ePRODUCT.PRef?
) -> Set<apPDM.eALTERNATE_PRODUCT_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: primaryBaseProductMaster, 
		ROLE: \apPDM.eALTERNATE_PRODUCT_RELATIONSHIP.BASE) 
	return Set(usedin)
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
///
public func substituteComponents(
	for primaryBaseComponentUsage: apPDM.eASSEMBLY_COMPONENT_USAGE.PRef?
) -> Set<apPDM.eASSEMBLY_COMPONENT_USAGE_SUBSTITUTE.PRef>
{
	let usedin = SDAI.USEDIN(
		T: primaryBaseComponentUsage, 
		ROLE: \apPDM.eASSEMBLY_COMPONENT_USAGE_SUBSTITUTE.BASE) 
	return Set(usedin)
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
///
public func makeFroms(
	of resultantProduct: apPDM.ePRODUCT_DEFINITION.PRef?
) -> Set<apPDM.eMAKE_FROM_USAGE_OPTION.PRef>
{
	let usedin = SDAI.USEDIN(
		T: resultantProduct, 
		ROLE: \apPDM.eMAKE_FROM_USAGE_OPTION.RELATING_PRODUCT_DEFINITION) 
	return Set(usedin)
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
///
public func venderPartIdentifications(
	for internalPartVersion: apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: internalPartVersion, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.RELATING_PRODUCT_DEFINITION_FORMATION) 
	let suppliedItems = usedin.filter{ $0.NAME == "supplied item" } 
	return Set(suppliedItems)
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
///
public func internalPartIdentifications(
	for venderPartVersion: apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: venderPartVersion, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.RELATED_PRODUCT_DEFINITION_FORMATION) 
	let suppliedItems = usedin.filter{ $0.NAME == "supplied item" } 
	return Set(suppliedItems)
}

//MARK: - Version History Relationship


/// obtains successor versions of a given product version
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
///
public func successorVersions(
	of productVersion: apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productVersion, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.RELATING_PRODUCT_DEFINITION_FORMATION) 
	let successors = usedin.filter{ $0.NAME == "sequence" || $0.NAME == "hierarchy" } 
	return Set(successors)
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
///
public func precedingVersion(
	of productVersion: apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?
) throws -> apPDM.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: productVersion, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_FORMATION_RELATIONSHIP.RELATED_PRODUCT_DEFINITION_FORMATION) )
	let precedings = usedin.filter{ $0.NAME == "sequence" || $0.NAME == "hierarchy" } 
	guard precedings.count <= 1 else {
		throw PDMkitError.multiplePrecedingVersions(precedings)
	}
	return precedings.first
}


