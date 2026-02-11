# §7 External Files

**External File References and Associations in the PDM Schema**

## Overview

External files in the PDM Schema represent a simple external reference to a named file. The external file may identify a digital file or a physical, 'hardcopy' file. As opposed to a managed 'Document as Product', an external file is not managed by the system - there is no capability for managed revision control or any document representation definitions for an external file.

An external file is simply an external reference that may be associated with other product data. Document/file properties may be associated with an external file as with an identified managed document. In the case where properties differ with different versions, the managed 'Document as Product' approach is recommended.

If a file is under configuration control, it should be represented as a constituent of a document definition view/representation according to 'Document as Product'. In this case, it is actually the managed document that is under direct configuration control; the file is, in this way, indirectly under configuration control. A change to the file results in a change to the managed document (i.e., a new version) - the changed file would be mapped as a constituent of a view/representation definition of the new document version. A simple external reference alone is not configuration controlled, it is just an external file reference to product data.

While managed revision control representing multiple versions and version history is not available for external files, external files may have an optional version identification providing a string labeling the version of the file.


## Topics

### 7.1 External File Identification
### 7.1.1 document_file

- ``documentFiles(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``documentFiles(for:)-(apPDM.ePRODUCT_DEFINITION_WITH_ASSOCIATED_DOCUMENTS.PRef)``

- ``documentFile(of:)-(apPDM.eAPPLIED_DOCUMENT_REFERENCE.PRef)``
- ``documentFile(as:)-(apPDM.eDOCUMENT.PRef?)``

### 7.1.2 document_representation_type

- ``representationType(of:)-(apPDM.eDOCUMENT_FILE.PRef?)``

### 7.1.3 document_type

- ``type(of:)-(apPDM.eDOCUMENT_FILE.PRef)``

### 7.1.4 applied_identification_assignment

- ``version(of:)-(apPDM.eDOCUMENT_FILE.PRef?)``

### 7.1.5 identification_role


