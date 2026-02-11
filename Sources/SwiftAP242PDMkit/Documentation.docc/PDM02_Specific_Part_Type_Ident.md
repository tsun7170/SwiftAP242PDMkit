# §2 Specific Part Type Classification

**Specific Classification of Product Types in the PDM Schema**

## Overview

A simple basic type of classification of products in STEP works by assigning categories to product data items. These categories are identified by name labels that define the related classification. This type of classification is referred to as specific classification.

NOTE - As an advanced requirement there might be the need to classify product data items according to a classification system with explicit reference to the classification criteria and related properties of the product data items. This classification mechanism is called general classification. The PDM Schema currently only supports the specific classification of product data items via assigned categories, which are defined by labeling them with a name.


## Topics

### 2.1 Classification of parts and managed documents

- ``categories(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``topLevelCategories(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``superCategory(of:)-(apPDM.ePRODUCT_CATEGORY.PRef?)``
- ``subCategories(of:)-(apPDM.ePRODUCT_CATEGORY.PRef?)``
- ``categoryLevel(of:)-(apPDM.ePRODUCT_CATEGORY.PRef?)``
- ``HierarchyLevel``
- ``topLevel``
- ``categories(of:)-(apPDM.ePRODUCT.PRef?)``
- ``product(_:belongsTo:)``

