//
//  ProductTypeClassification.swift
//
//
//  Created by Yoshida on 2021/08/21.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
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
///
public func categories(
	in domain: SDAIPopulationSchema.SchemaInstance
) throws -> [String:apPDM.ePRODUCT_CATEGORY.PRef]
{
	let instances = domain.entityExtent(type: apPDM.ePRODUCT_CATEGORY.self)

	let dict = try Dictionary(
		instances.lazy.map{ ($0.NAME.asSwiftType, $0.pRef) },
		uniquingKeysWith: { (value1,value2) in
			throw PDMkitError.duplicatedCategoryName(value1, value2)
		}
	)
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
///
public func topLevelCategories(
	in domain: SDAIPopulationSchema.SchemaInstance
) throws -> [String:apPDM.ePRODUCT_CATEGORY.PRef]
{
	var dict = try categories(in: domain)
	for (name,cat) in dict {
		let _ = SDAI.USEDIN(
			T: cat,
			ROLE: \apPDM.ePRODUCT_CATEGORY_RELATIONSHIP.SUB_CATEGORY)
		dict[name] = nil
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
///
public func superCategory(
	of category: apPDM.ePRODUCT_CATEGORY.PRef?
) throws -> apPDM.ePRODUCT_CATEGORY.PRef?
{
	let usedin = Set(SDAI.USEDIN(
		T: category,
		ROLE: \apPDM.ePRODUCT_CATEGORY_RELATIONSHIP.SUB_CATEGORY))
	guard usedin.count <= 1 else {
		throw PDMkitError.multipleSuperCategories(usedin)
	}
	return usedin.first?.CATEGORY
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
///
public func subCategories(
	of category: apPDM.ePRODUCT_CATEGORY.PRef?
) -> Set<apPDM.ePRODUCT_CATEGORY.PRef>
{
	let usedin = SDAI.USEDIN(
		T: category,
		ROLE: \apPDM.ePRODUCT_CATEGORY_RELATIONSHIP.CATEGORY)
	return Set(usedin.compactMap{ $0.SUB_CATEGORY })
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
///
public func categoryLevel(
	of category: apPDM.ePRODUCT_CATEGORY.PRef?
) throws -> HierarchyLevel
{
	if let superCategory = try superCategory(of: category) {
		let level = try categoryLevel(of: superCategory) + 1
		return level
	}
	else {
		return topLevel
	}
}

/// obtains all the categories to which a given product belongs to
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
///
public func categories(
	of productMaster: apPDM.ePRODUCT.PRef?
) -> Set<apPDM.ePRODUCT_RELATED_PRODUCT_CATEGORY.PRef>
{
	let usedin = SDAI.USEDIN(
		T: productMaster,
		ROLE: \apPDM.ePRODUCT_RELATED_PRODUCT_CATEGORY.PRODUCTS)
	return Set(usedin)
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
///
public func product(
	_ productMaster: apPDM.ePRODUCT.PRef,
	belongsTo category: apPDM.ePRODUCT_CATEGORY.PRef
) -> Bool
{
	if let cat = category.sub_ePRODUCT_RELATED_PRODUCT_CATEGORY {
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

