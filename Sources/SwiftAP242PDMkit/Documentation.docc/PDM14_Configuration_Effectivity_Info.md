# §14 Configuration and Effectivity Information

**Configuration and Effectivity Information inthe PDM Schema**

## Overview

The PDM Schema supports the definition of product concepts, which define products from a market or customer oriented viewpoint. As they are offered to the customers, these product concepts often define conceptual 'product models' which are available or delivered to the customer in different configurations or variations.

NOTE - If the number of possible variations of a product concept is too large, it might not be suitable to explicitly specify and manage all existing configurations of that product concept. The members of a product concept might therefore be defined implicitly by identifying the product features that characterize it or are available for it as options. Conditions among those features may be specified to manage dependencies and define the valid product variations for a particular product concept. This implicit definition of the configurations available for a certain product concept is suitable for customer option and variant specification: once all options are specified a single configuration is determined that may be represented explicitly for downstream application. Implicit definition of configurations is not contained in this version of the PDM Schema.

Configuration identification in the PDM Schema is the identification of product concepts and their associated configurations, the composition of which is to be managed. If a configuration of a product concept is implemented by a certain design, i.e., a particular part version, this version can be associated with the configuration and managed using configuration effectivity.

NOTE - Explicit representation of the configurations of a product concept is suitable for management of design as-planned manufacturing configurations, the traditional BOM inputs to manufacturing resource planning. These explicit configurations may also be suitable for management of other activities 'downstream' from the design phase, such as as-built and as-maintained configurations.

Configuration effectivity in the PDM Schema allows attachment of effectivity information to occurrences of component parts in the context of a particular configuration item. This enables specification of the valid use of a part occurrence in the context of a lot, serial number range or time period of a particular product configuration. This controls the constituent parts that are planned to be used for manufacturing end items of a particular product configuration within a dated time period or for a certain lot or serial number range of the end items.

While configuration effectivity is used to define the planned usage of components in the context of a particular product configuration, the PDM Schema also allows assignment of general validity periods to product data that control the usage of these product data independent of any particular life cycle or context.


## Topics

### 14.1 Configuration Identification
### 14.1.1 Product Concept Identification

- ``productConcepts(in:)-(SDAIPopulationSchema.SchemaInstance)``

### 14.1.2 Product Concept Configuration Identification

- ``productConfigurations(for:)-(apPDM.ePRODUCT_CONCEPT.PRef?)``
- ``configurationDesigns(for:)-(apPDM.eCONFIGURATION_ITEM.PRef?)``

### 14.2 Configuration Composition Management
### 14.2.1 Configuration effectivity

- ``usageEffectivities(in:)-(apPDM.eCONFIGURATION_DESIGN.PRef?)``
- ``usageEffectivities(of:)-(apPDM.ePRODUCT_DEFINITION_RELATIONSHIP.PRef?)``
- ``generalValidityEfectivities(for:)-(apPDM.sEFFECTIVITY_ITEM?)``
- ``relatedEffectivities(of:)-(apPDM.eEFFECTIVITY.PRef?)``
- ``relatingEffectivities(of:)-(apPDM.eEFFECTIVITY.PRef?)``

### 14.3 General Validity Period
### 14.3.1 General validity period effectivity


