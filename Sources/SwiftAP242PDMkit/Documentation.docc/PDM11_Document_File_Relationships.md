# §11 Document and File Relationships

**Relationships Among Documents, Files, and Their Versions in the PDM Schema**

## Overview

This section discusses relationships between files, document representation and sequence structure relationships between versions of managed documents.

The PDM Schema supports the definition of document structure by defining relationships of the representations of the documents using the entity product_definition_relationship. The PDM Schema supports the definition of corresponding relationships between document_file instances via the entity document_relationship. In addition, the PDM Schema supports the definition of relations between versions of a managed document to model document history.


## Topics

### 11.1 'Sequence' relationships between document versions
### 11.2 Relationships between document representations

- ``relatedProductDefinitions(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``relatingProductDefinitions(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``

### 11.3 Relationships between external files

- ``relatedDocuments(of:)-(apPDM.eDOCUMENT.PRef?)``
- ``relatingDocuments(of:)-(apPDM.eDOCUMENT.PRef?)``



