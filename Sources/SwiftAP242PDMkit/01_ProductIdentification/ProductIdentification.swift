//
//  File.swift
//  
//
//  Created by Yoshida on 2021/08/21.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


//MARK: - product related

/// obtains all product masters contained in a schema instance
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
public func products(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.ePRODUCT> {
	let instances = domain.entityExtent(type: ap242.ePRODUCT.self)
	return Set(instances)
}

/// obtains all product masters classified under the specified category and its sub categories
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
public func products(under category: ap242.ePRODUCT_CATEGORY) -> Set<ap242.ePRODUCT> {
	var result: Set<ap242.ePRODUCT> = []
	if let productRelated = ap242.ePRODUCT_RELATED_PRODUCT_CATEGORY(category) {
		result = productRelated.PRODUCTS.asSwiftType
	}	
	for subcat in subCategories(of: category) {
		result.formUnion(products(under: subcat))
	}
	return result
}

/// all versions of the base product master
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
public func versions(of productMaster: ap242.ePRODUCT) -> Set<ap242.ePRODUCT_DEFINITION_FORMATION> {
	if let usedin = SDAI.USEDIN(
			T: productMaster, 
			ROLE: \ap242.ePRODUCT_DEFINITION_FORMATION.OF_PRODUCT)?
			.asSwiftType {
		return Set(usedin)
	}
	return []
}

//MARK: - product definition formation related

/// obtains all views on a version of a product
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
public func views(of productVersion: ap242.ePRODUCT_DEFINITION_FORMATION) -> Set<ap242.ePRODUCT_DEFINITION> {
	if let usedin = SDAI.USEDIN(
			T: productVersion, 
			ROLE: \ap242.ePRODUCT_DEFINITION.FORMATION)?
			.asSwiftType {
		return Set(usedin)
	}
	return []
}

/// obtains all views of a version of a document product
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
public func documentViews(of documentProductVersion: ap242.ePRODUCT_DEFINITION_FORMATION) -> Set<ap242.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS> {
	if let usedin = SDAI.USEDIN(
			T: documentProductVersion, 
			ROLE: \ap242.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.FORMATION)?
			.asSwiftType {
		return Set(usedin)
	}
	return []
}



/// obtains a base product master associated with the product version
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
public func masterBase(of productVersion: ap242.ePRODUCT_DEFINITION_FORMATION) -> ap242.ePRODUCT {
	let master = productVersion.OF_PRODUCT
	return master
}

//MARK: - product definition related

/// obtains all product definitions contained in a schema instance
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
public func productDefinitions(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.ePRODUCT_DEFINITION> {
	let instances = domain.entityExtent(type: ap242.ePRODUCT_DEFINITION.self)
	return Set(instances)
}




/// obtains all document product definitions contained in a schema instance
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
public func documentProductDefinitions(in domain: SDAIPopulationSchema.SchemaInstance) -> Set<ap242.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS> {
	let instances = domain.entityExtent(type: ap242.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.self)
	return Set(instances)
}


/// obtains all product definitions belonged under specified category and its sub-categories
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
public func productDefinitions(under category: ap242.ePRODUCT_CATEGORY) -> Set<ap242.ePRODUCT_DEFINITION> {
	let masters = products(under: category)
	let pvers = Set(masters.lazy.flatMap { versions(of: $0) })
	let pdefs = Set(pvers.lazy.flatMap{ views(of: $0) })
	return pdefs
}

/// obtains a product version associated with the product definition
/// - Parameter productDefinition: product definition
/// - Returns: product version associated with the product definition
/// 
/// # Reference
/// 1.1.1 Product Master Identification; 
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func version(of productDefinition: ap242.ePRODUCT_DEFINITION) -> ap242.ePRODUCT_DEFINITION_FORMATION {
	return productDefinition.FORMATION
}

/// obtains a base product master associated with the product definition
/// - Parameter productDefinition: product definition
/// - Returns: product master associated with the product definition
/// 
/// # Reference
/// 1.1.1 Product Master Identification; 
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func masterBase(of productDefinition: ap242.ePRODUCT_DEFINITION) -> ap242.ePRODUCT {
	let pver = version(of: productDefinition)
	return masterBase(of: pver)
}
