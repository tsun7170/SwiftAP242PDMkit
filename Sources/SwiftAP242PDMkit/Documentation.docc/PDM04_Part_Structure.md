# §4 Part Structure and Relationships

**Assembly Structures and Part Relationships in the PDM Schema**

## Overview

The STEP PDM Schema supports explicit hierarchical product structures representing assemblies and the constituents of those assemblies. This explicit part structure corresponds to the traditional engineering and manufacturing bill of material indentured parts list. Relationships between part view definitions are the principle elements used to structure an explicit part assembly configuration. The relationship itself represents a specific usage occurrence of the constituent part definition within the immediate parent assembly definition. Mechanisms to represent quantity associated with this assembly-component usage relationship are also provided.

The PDM Schema also has the capability to identify and track a specified usage of a component definition in an assembly at a higher level than the immediate parent subassembly. Consider a wheel-axle subassembly composed of one axle and two wheels, the right and the left. A higher-level chassis assembly is in turn composed of two wheel-axle subassemblies, the front and the rear. The requirement to individually identify the left-front wheel, for example, is supported by this capability.

Different view definitions of the same version of a part may participate in different explicit product structures. For example, a design/as-planned view of a particular version of a part, representing the design discipline part definition, may be engaged in an explicit design assembly structure. A manufacturing/as-built view of the same part version represents the definitional template for the actual physical part, and may participate in a manufactured assembly structure that is different from the design assembly structure. Finally, a support/as-maintained view of the part version representing the physical part definition may participate in yet another different disassembly structure.

In addition to hierarchical assembly structures, the STEP PDM Schema supports relationships between parts to characterize explicit alternates and substitutes for the assembly. Other relationships between part definitions exist to characterize the make from relationship and for supplied part identification.

## Topics

### 4.1 Explicit Assembly Bill Of Material

- ``parentAssemblies(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``subComponents(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``topLevelProducts(in:)-(SDAIPopulationSchema.SchemaInstance)``


### 4.1.2 Quantified Component Usage
### 4.1.3 Multiple Individual Component Occurrences
### 4.1.4 Promissory Component Usage

- ``promissoryUsingAssemblies(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``promissoryUsedComponents(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``

### 4.2 Multi-Level Assembly Digital Mock Up

- ``specificHigherUsages(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``specificUseOccurrences(within:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``specificUsages(for:)-(apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef?)``

### 4.3 Different Views on Assembly Structure

### 4.4 Relating Part Shape Properties to Product Structure
### 4.4.1 Explicit Representation of Complete Assembly Geometry 

- ``explicitShape(of:)-(apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef?)``

### 4.4.2 Implicit Relationships Between Assembly Components 

- ``assemblyComponentTransformationRelationship(of:)-(apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef?)``
- ``asAssembledShape(of:)-(apPDM.eNEXT_ASSEMBLY_USAGE_OCCURRENCE.PRef?)``

### 4.4.3 Complete instantiation example for part structure with shape properties 

### 4.5.1 Alternate Parts 

- ``alternateProducts(for:)-(apPDM.ePRODUCT.PRef?)``


### 4.5.2 Substitute Components in an Assembly

- ``substituteComponents(for:)-(apPDM.eASSEMBLY_COMPONENT_USAGE.PRef?)``

### 4.5.3 Make From Relationships

- ``makeFroms(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``

### 4.5.4 Supplied Part Identification

- ``venderPartIdentifications(for:)-(apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?)``
- ``internalPartIdentifications(for:)-(apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?)``

### 4.5.5 Version History Relationships

- ``successorVersions(of:)-(apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?)``
- ``precedingVersion(of:)-(apPDM.ePRODUCT_DEFINITION_FORMATION.PRef?)``


### 4.7.1 Item Find Number
### 4.7.2 Mirroring of components


