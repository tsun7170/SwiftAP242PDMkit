//
//  File.swift
//  
//
//  Created by Yoshida on 2021/08/21.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242

/// obtains all product categories contained in the schema instance
/// - Parameter domain: schema instance
/// - Throws: duplicated category name error when multiple categories have the same NAME value
/// - Returns: dictionary of product categories keyed with category name
///  
/// # Reference
/// 1.1.3 Type Classification;    
/// 2 Specific Part Type Classification;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func categories(in domain: SDAIPopulationSchema.SchemaInstance) throws -> [String:ap242.ePRODUCT_CATEGORY] {
	let instances = domain.entityExtent(type: ap242.ePRODUCT_CATEGORY.self)
	let dict = try Dictionary(instances.lazy.map{ ($0.NAME.asSwiftType, $0) }) { 
		throw PDMkitError.duplicatedCatrgoryName($0, $1)
	}
	return dict
}

/// obtains all top level product categories in the schema instance
/// - Parameter domain: schema instance
/// - Throws: duplicated category name error when multiple categories have the same NAME value
/// - Returns: dictionary of top level product categories keyed with category name
///  
/// # Reference
/// 1.1.3 Type Classification; 
/// 1.1.3.2 product_category_relationship;
/// 2 Specific Part Type Classification;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func topLevelCategories(in domain: SDAIPopulationSchema.SchemaInstance) throws -> [String:ap242.ePRODUCT_CATEGORY] {
	var dict = try categories(in: domain)
	for (name,cat) in dict {
		if let _ = SDAI.USEDIN(
				T: cat, 
				ROLE: \ap242.ePRODUCT_CATEGORY_RELATIONSHIP.SUB_CATEGORY) {
			dict[name] = nil
		}
	}
	return dict
}

/// obtains a immediate super category of a given category if exist
/// - Parameter category: product category
/// - Throws: multiple super categories error
/// - Returns: immediate super category of a given category if exist
///
/// # Reference
/// 1.1.3 Type Classification; 
/// 1.1.3.2 product_category_relationship;
/// 2 Specific Part Type Classification;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func superCategory(of category: ap242.ePRODUCT_CATEGORY) throws -> ap242.ePRODUCT_CATEGORY? {
	if let usedin = SDAI.USEDIN(
			T: category, 
			ROLE: \ap242.ePRODUCT_CATEGORY_RELATIONSHIP.SUB_CATEGORY)?
			.asSwiftType {
		guard usedin.count <= 1 else {
			throw PDMkitError.multipleSuperCategories(usedin)
		}
		return usedin.first?.CATEGORY
	}
	return nil
}

/// obtains all immediate sub categories of a given category
/// - Parameter category: product category
/// - Returns: immediate sub categories of a given category
///  
/// # Reference
/// 1.1.3 Type Classification; 
/// 1.1.3.2 product_category_relationship;
/// 2 Specific Part Type Classification;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func subCategories(of category: ap242.ePRODUCT_CATEGORY) -> Set<ap242.ePRODUCT_CATEGORY> {
	if let usedin = SDAI.USEDIN(
			T: category, 
			ROLE: \ap242.ePRODUCT_CATEGORY_RELATIONSHIP.CATEGORY)?
			.asSwiftType {
		return Set(usedin.map{ $0.SUB_CATEGORY })
	}
	return []
}

public typealias HierarchyLevel = Int
public let topLevel: HierarchyLevel = 0

/// obtains a hierarchy level of a given category in category tree
/// - Parameter category: product category
/// - Throws: multiple super categories error
/// - Returns: hierarchy level of a given category
/// - top level value is defined as topLevel
///   
/// # Reference
/// 1.1.3 Type Classification; 
/// 1.1.3.2 product_category_relationship;
/// 2 Specific Part Type Classification;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func categoryLevel(of category: ap242.ePRODUCT_CATEGORY) throws -> HierarchyLevel {
	if let superCategory = try superCategory(of: category) {
		let level = try categoryLevel(of: superCategory) + 1
		return level
	}
	else {
		return topLevel
	}
}

/// obains all the categories to which a given product belongs to
/// - Parameter productMaster: product master
/// - Returns: all the categories to which a given product belongs to
///  
/// # Reference
/// 1.1.3 Type Classification; 
/// 1.1.3.2 product_category_relationship;
/// 2 Specific Part Type Classification;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func categories(of productMaster: ap242.ePRODUCT) -> Set<ap242.ePRODUCT_RELATED_PRODUCT_CATEGORY> {
	if let usedin = SDAI.USEDIN(
			T: productMaster, 
			ROLE: \ap242.ePRODUCT_RELATED_PRODUCT_CATEGORY.PRODUCTS)?
			.asSwiftType {
		return Set(usedin)
	}
	return []
}

/// check to see if a given product master belongs to a category
/// - Parameters:
///   - productMaster: product master
///   - category: category in question
/// - Returns: true when a given product master belongs to a category in question
///  
/// # Reference
/// 1.1.3 Type Classification; 
/// 1.1.3.2 product_category_relationship;
/// 2 Specific Part Type Classification;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum 
public func product(_ productMaster: ap242.ePRODUCT, belongsTo category: ap242.ePRODUCT_CATEGORY) -> Bool {
	if let cat = ap242.ePRODUCT_RELATED_PRODUCT_CATEGORY(category) {
		if cat.PRODUCTS.contains(productMaster) {
			return true
		}
	}
	for sub in subCategories(of: category) {
		if product(productMaster, belongsTo: sub) {
			return true
		}
	}
	return false
}

