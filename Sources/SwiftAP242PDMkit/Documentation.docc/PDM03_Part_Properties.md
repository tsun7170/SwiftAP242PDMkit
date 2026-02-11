# §3 Part Properties

**Properties and Geometric Representations of Parts in the PDM Schema**

## Overview

The PDM Schema allows specifying properties associated with parts. A property is the definition of a special quality and may reflect physics or arbitrary, user defined measurements. A general pattern for instantiating property information is used in the PDM Schema. A number of pre-defined property type names are also proposed for use when appropriate.

A special case of part properties is that of the part shape property - a representation of the geometrical shape model of the part. Various relationships are defined between external geometrical models to represent geometric model structure and the associated transformation information required for digital mock-up of assembly structures.


## Topics

### 3.1.1 Properties Associated with Product Data

- ``properties(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``properties(of:)-(apPDM.eDOCUMENT_FILE.PRef?)``
- ``representation(of:)-(apPDM.ePROPERTY_DEFINITION.PRef?)``
- ``context(of:)-(apPDM.eREPRESENTATION.PRef)``
- ``values(of:)-(apPDM.eREPRESENTATION.PRef)``

### 3.1.2 Independent Property Identification

- ``generalProperties(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``associations(of:)-(apPDM.eGENERAL_PROPERTY.PRef?)``
- ``propertyDefinition(of:)-(apPDM.eGENERAL_PROPERTY_ASSOCIATION.PRef)``
- ``relatedGeneralProperties(of:)-(apPDM.eGENERAL_PROPERTY.PRef?)``
- ``relatingGeneralProperties(of:)-(apPDM.eGENERAL_PROPERTY.PRef?)``

### 3.1.3 Pre-Defined Properties
### 3.1.4 Additional Part Properties

### 3.2.1 Geometric Shape Property
- ``shapeDefinitionRepresentations(in:)-(SDAIPopulationSchema.SchemaInstance?)``
- ``shape(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``representations(of:)-(apPDM.ePRODUCT_DEFINITION_SHAPE.PRef?)``
- ``shapeDefinition(of:)-(apPDM.eSHAPE_REPRESENTATION.PRef?)``
- ``productDefinition(of:)-(apPDM.eSHAPE_REPRESENTATION.PRef?)``
- ``context(of:)-(apPDM.eSHAPE_REPRESENTATION.PRef)``
- ``geometricItems(of:)-(apPDM.eSHAPE_REPRESENTATION.PRef)``


### 3.2.2 Portions of the Part Shape

- ``shapeAspects(of:)-(apPDM.ePRODUCT_DEFINITION_SHAPE.PRef?)``
- ``representations(of:)-(apPDM.eSHAPE_ASPECT.PRef?)``

### 3.2.3 Relating Externally Defined Part Shape to an External File

- ``definitionalShapeApplications(of:)-(Set<apPDM.eDOCUMENT.PRef>)``

- ``definitionalShapeDefinitions(of:)-(apPDM.eSHAPE_REPRESENTATION.PRef?)``

### 3.2.4 Splitting shape into multiple shape representations

### 3.3.1 Relating Part Shape

- ``shapeRepresentationRelationships(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``relatedShapeRep1s(to:)-(apPDM.eSHAPE_REPRESENTATION.PRef?)``
- ``relatedShapeRep2s(to:)-(apPDM.eSHAPE_REPRESENTATION.PRef?)``

### 3.3.2 Relating portions of shape to each other
### 3.3.3 Additional Geometric Model Structures

### 3.4.1 Implicitly defined transformations between geometric models
### 3.4.2 Explicitly defined transformations between geometric models
### 3.4.3 Conversion from Implicit to Explicit Transformation Information

### 3.5.1 Material properties
### 3.5.2 Mapping of part properties in AP 214

