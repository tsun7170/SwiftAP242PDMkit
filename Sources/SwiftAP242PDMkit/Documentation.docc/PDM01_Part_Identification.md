# §1 Part Identification

**Part and Document Identification in the PDM Schema**

## Overview

The PDM Schema manages all parts as products, according to a fundamental STEP interpretation of 'Part as Product'. Part identification is achieved using basic product identification. In addition, a product may represent a managed document and be identified according to the 'Document as Product' interpretation (see Section 5.1).

Part identification is the center for assignment of further product management data. As a consequence, at least one product identification (part or document) must be instantiated for the exchange of part/document data in the STEP PDM Schema.
The simple alias concept supports assignment of an alternate identifier to a product. This mechanism may also be used to alias other elements of product data.

Do not use the alias identification for the requirement of supplied part or document identification. This more complex alias relationship concept is specific for identification and renumbering of supplier's parts and documents. See Supplied Part Identification 4.5.4 and Alias Identification 12


## Topics

### 1.1.1 Product Master Identification

- ``products(in:)``
- ``products(under:)``
- ``versions(of:)``

- ``views(of:)``
- ``documentViews(of:)``
- ``masterBase(of:)-(apPDM.ePRODUCT_DEFINITION_FORMATION.PRef)``

- ``productDefinitions(in:)``
- ``documentProductDefinitions(in:)``
- ``productDefinitions(under:)``
- ``version(of:)-(apPDM.ePRODUCT_DEFINITION.PRef)``
- ``masterBase(of:)-(apPDM.ePRODUCT_DEFINITION.PRef)``


### 1.1.2 Context Information

- ``contexts(of:)-(apPDM.ePRODUCT.PRef)``
- ``applicationContext(of:)-(apPDM.ePRODUCT_CONTEXT.PRef)``
- ``applicationContext(of:)-(apPDM.ePRODUCT_DEFINITION_CONTEXT.PRef)``
- ``applicationProtocol(of:)-(apPDM.eAPPLICATION_CONTEXT.PRef?)``
- ``primaryContext(of:)-(apPDM.ePRODUCT_DEFINITION.PRef)``
- ``additionalContexts(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``

### 1.1.3 Type Classification

- ``products(under:)``
- ``productDefinitions(under:)``

- ``categories(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``topLevelCategories(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``superCategory(of:)-(apPDM.ePRODUCT_CATEGORY.PRef?)``
- ``subCategories(of:)-(apPDM.ePRODUCT_CATEGORY.PRef?)``
- ``categoryLevel(of:)-(apPDM.ePRODUCT_CATEGORY.PRef?)``
- ``HierarchyLevel``
- ``topLevel``
- ``categories(of:)-(apPDM.ePRODUCT.PRef?)``
- ``product(_:belongsTo:)``
