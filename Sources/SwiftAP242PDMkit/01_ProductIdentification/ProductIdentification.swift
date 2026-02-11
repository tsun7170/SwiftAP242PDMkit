//
//  ProductIdentification.swift
//  
//
//  Created by Yoshida on 2021/08/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


//MARK: - product related

/// obtains all product masters contained in a schema instance (1.1.1.1)
/// - Parameter domain: schema instance
/// - Returns: all product masters found
/// 
/// # Reference
/// 1.1.1 Product Master Identification; 
/// 1.1.1.1 product;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func products(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.ePRODUCT.PRef>
{
	let instances = domain.entityExtent(type: apPDM.ePRODUCT.self)
	return Set( instances.map{$0.pRef} )
}

/// obtains all product masters classified under the specified category and its sub categories (1.1.1)(1.1.3)
/// - Parameter category: product category
/// - Returns: all product masters found
/// 
/// # Reference
/// 1.1.3 Type Classification;
/// 1.1.1 Product Master Identification; 
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func products(
	under category: apPDM.ePRODUCT_CATEGORY.PRef
) -> Set<apPDM.ePRODUCT.PRef>
{
	var result: Set<apPDM.ePRODUCT.PRef> = []
	if let productRelated = category.sub_ePRODUCT_RELATED_PRODUCT_CATEGORY {
		result = productRelated.PRODUCTS.asSwiftType
	}	
	for subcat in subCategories(of: category) {
		result.formUnion(products(under: subcat))
	}
	return result
}

/// all versions of the base product master (1.1.1.2)
/// - Parameter productMaster: base product master
/// - Returns: all product definition formations associated
/// 
/// # Reference
/// 1.1.1 Product Master Identification; 
/// 1.1.1.2 product_definition_formation;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func versions(
	of productMaster: apPDM.ePRODUCT.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION_FORMATION.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productMaster, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_FORMATION.OF_PRODUCT)
	return Set(usedin)
}

//MARK: - product definition formation related

/// obtains all views on a version of a product (1.1.1.4)
/// - Parameter productVersion: product version
/// - Returns: all views associated with a product version
/// 
/// # Reference
/// 1.1.1 Product Master Identification; 
/// 1.1.1.4 product_definition;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func views(
	of productVersion: apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productVersion, 
		ROLE: \apPDM.ePRODUCT_DEFINITION.FORMATION)
	return Set(usedin)
}

/// obtains all views of a version of a document product (8.1.1)
/// - Parameter documentProductVersion: document product version
/// - Returns: all document views associated with a document product version
/// 
/// # Reference
/// 8.1 Product Definition with associated documents;
/// 8.1.1 product_definition_with_associated_documents;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func documentViews(
	of documentProductVersion: apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?
) -> Set<apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.PRef>
{
	let usedin = SDAI.USEDIN(
		T: documentProductVersion, 
		ROLE: \apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.FORMATION)
	return Set(usedin)
}



/// obtains a base product master associated with the product version (1.1.1.2)
/// - Parameter productVersion: product version
/// - Returns: product master associated with the product version
/// 
/// # Reference
/// 1.1.1 Product Master Identification; 
/// 1.1.1.2 product_definition_formation;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func masterBase(
	of productVersion: apPDM.ePRODUCT_DEFINITION_FORMATION.PRef
) -> apPDM.ePRODUCT.PRef
{
	let master = productVersion.OF_PRODUCT
	return SDAI.UNWRAP(master)
}

//MARK: - product definition related

/// obtains all product definitions contained in a schema instance (1.1.1.4)
/// - Parameter domain: schema instance
/// - Returns: all product definitions found
/// 
/// # Reference
/// 1.1.1 Product Master Identification; 
/// 1.1.1.4 product_definition;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func productDefinitions(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.ePRODUCT_DEFINITION.PRef>
{
	let instances = domain.entityExtent(type: apPDM.ePRODUCT_DEFINITION.self)
	return Set( instances.map{$0.pRef} )
}




/// obtains all document product definitions contained in a schema instance (8.1.1)
/// - Parameter domain: schema instance
/// - Returns: all document product definition found
/// 
/// # Reference
/// 8.1 Product Definition with associated documents;
/// 8.1.1 product_definition_with_associated_documents;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func documentProductDefinitions(
	in domain: SDAIPopulationSchema.SchemaInstance
) -> Set<apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.PRef>
{
	let instances = domain.entityExtent(type: apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.self)
	return Set( instances.map{$0.pRef} )
}


/// obtains all product definitions belonged under specified category and its sub-categories (1.1.1)(1.1.3)
/// - Parameter category: product category
/// - Returns: product definitions found
/// 
/// # Reference
/// 1.1.3 Type Classification;
/// 1.1.1 Product Master Identification; 
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func productDefinitions(
	under category: apPDM.ePRODUCT_CATEGORY.PRef
) -> Set<apPDM.ePRODUCT_DEFINITION.PRef>
{
	let masters = products(under: category)
	let pvers = Set(masters.lazy.flatMap { versions(of: $0) })
	let pdefs = Set(pvers.lazy.flatMap{ views(of: $0) })
	return pdefs
}

/// obtains a product version associated with the product definition (1.1.1)
/// - Parameter productDefinition: product definition
/// - Returns: product version associated with the product definition
/// 
/// # Reference
/// 1.1.1 Product Master Identification; 
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func version(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef
) -> apPDM.ePRODUCT_DEFINITION_FORMATION.PRef
{
	return SDAI.UNWRAP(productDefinition.FORMATION)
}

/// obtains a base product master associated with the product definition (1.1.1)
/// - Parameter productDefinition: product definition
/// - Returns: product master associated with the product definition
/// 
/// # Reference
/// 1.1.1 Product Master Identification; 
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func masterBase(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef
) -> apPDM.ePRODUCT.PRef
{
	let pver = version(of: productDefinition)
	return masterBase(of: pver)
}
