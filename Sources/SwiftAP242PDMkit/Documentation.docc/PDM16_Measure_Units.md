# §16 Measure and Units

**Measure and Units in the PDM Schema**

## Overview

A measure with unit is the specification of a physical quantity as defined in ISO31 (clause 2). The PDM Schema allows specifying different measure with units used for, e.g., a property definition or quantity of an assembly relationship. A measure with unit is characterized by two components, a value specifying the quantity and a unit in which the value is expressed.

The PDM Schema supports the application of:
* simple units including predefined SI units according to ISO1000 (clause 2);
* converted units which are derived from another unit by a conversion factor;
* derived units which are defined by an expression of units;
* user defined units which are dependent on a specific context and which are not related to the system of
units within the PDM Schema.


## topics   

### 16.1 Measure with unit specification
- ``apPDM/eMEASURE_WITH_UNIT``

### 16.2 Unit definition
### 16.2.1 Simple and predefined units
- ``apPDM/eNAMED_UNIT``
- ``apPDM/eDIMENSIONAL_EXPONENTS``
- ``apPDM/eSI_UNIT``


### 16.2.2 Converted units
- ``apPDM/eCONVERSION_BASED_UNIT``


### 16.2.3 Derived units
- ``apPDM/eDERIVED_UNIT``
- ``apPDM/eDERIVED_UNIT_ELEMENT``

### 16.2.4 User defined units
- ``apPDM/eCONTEXT_DEPENDENT_UNIT``

