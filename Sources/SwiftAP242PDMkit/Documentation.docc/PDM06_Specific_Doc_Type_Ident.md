# §6 Specific Document Type Classification

**Specific Classification of Document Types in the PDM Schema**

## Overview

The PDM Schema supports the specific classification of both parts and managed documents.
Consequentially, following the 'document as product' approach as described in this usage guide, the type classification of managed documents is done in symmetry to the specific type classification for parts.


## Topics

### 6.1 Product Related Product Category and Product Category Relationship

- ``categories(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``topLevelCategories(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``superCategory(of:)-(apPDM.ePRODUCT_CATEGORY.PRef?)``
- ``subCategories(of:)-(apPDM.ePRODUCT_CATEGORY.PRef?)``
- ``categoryLevel(of:)-(apPDM.ePRODUCT_CATEGORY.PRef?)``
- ``HierarchyLevel``
- ``topLevel``
- ``categories(of:)-(apPDM.ePRODUCT.PRef?)``
- ``product(_:belongsTo:)``

