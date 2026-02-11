# §9 Document and File Properties

**Document and File Properties in the PDM Schema**

## Overview

PDM Schema document properties can be associated to representations of documents as well as to individual files. If document properties are assigned to representations of documents, the characteristics apply as well to all the constituent files of the document representation in most cases. Some properties with numeric values, such as 'file size' and 'page count', applied to the document representation will not correspond to an individual file in a multiple file document representation, but to the sum of all the files that make up the particular document representation definition. To avoid redundancy it is recommended that properties that are shared by all constituents of a given document representation are directly associated with that document representation rather than replicated with the individual files.


## Topics

- ``properties(of:)-(apPDM.eDOCUMENT_FILE.PRef?)``

### 9.1 Product Definition or Document Representation

- ``values(of:)-(apPDM.eREPRESENTATION.PRef)``

### 9.2 Document content property
### 9.3 Document creation property
### 9.4 Document format property
### 9.5 Document size property
### 9.6 Document source property

- ``DocumentSourceProperty``

- ``sourceProperties(of:)-(apPDM.eDOCUMENT_FILE.PRef?)``
- ``sourceProperties(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``sourceProperties(of:)-(apPDM.sEXTERNAL_IDENTIFICATION_ITEM?)``

- ``fileLocations(of:)-(apPDM.eDOCUMENT_FILE.PRef)``
- ``documentFormat(of:)-(apPDM.eDOCUMENT_FILE.PRef?)``

### 9.7 Additional Document Properties
### 9.8 Document type classification



