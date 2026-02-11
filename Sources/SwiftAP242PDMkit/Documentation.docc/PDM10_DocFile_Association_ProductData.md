# §10 Document and File Association with Product Data

**Associating Documents and Files with Product Data in the PDM Schema**

## Overview

In 'Document as Product' documents and external files may be associated with product data. This association is done in a consistent way using an applied reference with a specified role. The applied reference is realized structurally by the PDM Schema entities document and applied_document_reference.

When associating a managed 'Document as Product' to product data, the document master is linked to the applied reference constructs using the additional entity document_product_equivalence. This linkage may be made at the level of the base identification, the document version, or the document representation view definition. The recommended level from which a document master should reference other product data is the document version.

External files may also be associated with product data, in a way that is structurally consistent with that used for documents, using the entity applied_document_reference.


## Topics

### 10.1 Document Reference

- ``associatedDocuments(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``associatedDocuments(of:)-(apPDM.sDOCUMENT_REFERENCE_ITEM?)``
- ``managedDocument(of:)-(apPDM.eAPPLIED_DOCUMENT_REFERENCE.PRef)``
- ``managedDocument(of:)-(apPDM.eDOCUMENT.PRef?)``

- ``applications(of:)-(Set<apPDM.eDOCUMENT.PRef>)``
- ``definitionalShapeApplications(of:)-(Set<apPDM.eDOCUMENT.PRef>)``

### 10.2 External File Reference

- ``documentFile(of:)-(apPDM.eAPPLIED_DOCUMENT_REFERENCE.PRef)``
- ``documentFile(as:)-(apPDM.eDOCUMENT.PRef?)``
- ``documentReferences(of:)-(apPDM.eDOCUMENT_FILE.PRef)``

### 10.3 Constrained Document or File Reference

- ``associatedDocumentPortions(of:)-(apPDM.ePRODUCT_DEFINITION.PRef?)``
- ``associatedDocumentPortions(of:)-(apPDM.sDOCUMENT_REFERENCE_ITEM?)``
- ``managedDocument(of:)-(apPDM.eDOCUMENT_USAGE_CONSTRAINT.PRef)``
- ``documentFile(of:)-(apPDM.eDOCUMENT_USAGE_CONSTRAINT.PRef)``




