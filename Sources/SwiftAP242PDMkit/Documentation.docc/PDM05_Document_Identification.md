# §5 Document Identification

**Document Identification and Management in the PDM Schema**

## Overview

The PDM Schema deals with documents as products, according to a basic STEP interpretation of
'Document as Product'. As with 'Part as Product', there are three basic concepts central to document
identification in the PDM Schema:
* product master identification,
* context information,
* type classification.
These fundamental concepts are described for 'Part as Product' in this document. The following provides specifics on the distinction and additions for the 'Document as Product' approach.

'Document as Product' identifies a managed document object in a PDM system. A managed document is under revision control, and may distinguish various representation definitions of a document version. The document_version represents the minimum identification of a managed document under revision control. A document representation definition may optionally be associated with one or more constituent external files that make it up.

EXAMPLE - a configuration controlled managed paper document such as a drawing would generally map to a usage of the entity 'product', with version identification and a (physical) representation/view definition according to the 'document as product' approach.

External files in the PDM Schema represent a simple external reference to a named file. An external file is not managed independently by the system - there is usually no revision control or any representation definitions of external files. Version identification may optionally be associated with an external file, but this is for information only and is not used for managed revision control.

If a file is under configuration control, it should be represented as a constituent of a document definition view/representation. In this case it is actually the managed document that is under direct configuration control, the file is in this way indirectly under configuration control. A change to the file results in a change to the managed document (i.e., a new version) - the changed file would be mapped as a constituent of a view/representation definition of the new document version. A simple external reference alone is not configuration controlled; it is just an external file reference to product data.

Documents may be associated with product data in a specified role, to represent some relationship between a document and other elements of product data. Constraints may also be specified on this association, in order to distinguish an applicable portion of an entire document or file in the association. With 'Document as Product', additional entities are required to relate a managed document to other product data (see Section 10.1). Included among these is the entity document. The document.id should not be used as valid user data - the document entity does not always need to be instantiated using 'Document as Product', it is done only to assign the document to other product data via applied_document_reference.


## Topics

### 5.1.1 Document Master Identification
### 5.1.2 Context Information

- ``contexts(of:)-(apPDM.ePRODUCT.PRef)``
- ``primaryContext(of:)-(apPDM.ePRODUCT_DEFINITION.PRef)``

### 5.1.3 Type Classification




