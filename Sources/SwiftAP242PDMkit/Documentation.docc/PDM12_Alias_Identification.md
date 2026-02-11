# §12 Alias Identification

**Alias Identification in the PDM Schema**

## Overview

An alias identification is a mechanism to associate an object with an additional identifier that is used to identify the object of interest in a different context, either in another organization, or in some other context. The alias identification mechanism shall not be used to alias supplied parts. See Supplied Part Identification 4.5.4.

The scope of the alias identification shall be specified either by the description of the associated identification_role or – if the scope is defined by an organization – with help of an applied_organization_- assignment. The scope of an alias defines the context in which the id specified via applied_identification_- assignment.assigned_id overrides the original id. A scenario might be that an object has an id in the context of the organization assigned in the role 'id owner' as a primary id and other ids defined via aliases that are valid in the context of some other organizations.


## Topics

### 12 Alias Identification

- ``aliases(for:)-(apPDM.sIDENTIFICATION_ITEM?)``

