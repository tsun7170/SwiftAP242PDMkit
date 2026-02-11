# §8 Relationship Between Documents and Constituent Files

**Relationships Between Documents and Their Constituent Files in the PDM Schema**

## Overview

In 'Document as Product', the view definition is used to represent a definition of a particular document representation. There may be more than one representation definition associated with a document version. The document representation definition may be associated with the constituent external files that make it up. The association of constituent files with the definition of a document representation is optional.

If a file is under configuration control, it should be represented as a constituent of a document definition view/representation. In this case it is actually the managed document that is under direct configuration control, the file is in this way indirectly under configuration control. A change to the file results in a change to the managed document (i.e., a new version) - the changed file would be mapped as a constituent of a view/representation definition of the new document version. A simple external reference alone is not configuration controlled; it is just an external file reference to product data.


## Topics

### 8.1 Product Definition with associated documents

- ``documentViews(of:)``
- ``documentProductDefinitions(in:)``

- ``externalFiles(of:)-(apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.PRef)``

- ``documentFiles(for:)-(apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.PRef)``

- ``documentReferences(of:)-(apPDM.eDOCUMENT_FILE.PRef)``

