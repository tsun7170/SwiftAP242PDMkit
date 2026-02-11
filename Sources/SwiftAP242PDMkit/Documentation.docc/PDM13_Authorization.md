# §13 Authorization

**Authrization in the PDM Schema**

## Overview

**Organization and Person**    
The PDM Schema represents organizations and people in organizations as they perform functions related to other product data and data relationships. A person in the PDM Schema must exist in the context of some organization. An organization or a person in an organization is then associated with the data or data relationship in some role indicating the function being performed. Both people and organizations may have addresses associated with them. The address is entirely optional; it is done through the address entity being related to the person (through personal_address) or organization (through organizational_address).


**Approval**    
Approving in the PDM Schema is accomplished by establishing an approval entity and relating it to some construct through an applied_approval_assignment. The applied_approval_assignment entity may have a role associated with it through the entity role_association and its related object_role entity to indicate the reason/role of this approval related to the particular element of product data.

Approval may be represented as a simple basic approval (see 13.2.1), or it may represent a more complex approval cycle involving multiple approvers, on different dates/times, and possibly with different status values (see 13.2.2).

In the case of a single approval instance with multiple people signing off on the approval, approval_person_organization can be applied to the date_and_time_item select type.

In the case where an approval is made up of multiple approval instances, and these approvals involve hierarchical relationships, applying date to an approval_person_organization should not be used, because in Multiple approvals with Hierarchical relationships an applied_data_and_time applied to approval_person_organization is not needed. In these kinds of approvals, there should be an approval_person_organization and approval_date_time for each approval instance. Date and time are already available by instantiating an approval_date_time construct for each approval in a multiple approval hierarchical relationship structure.

Approval is part of the select type organization_item, and it provides the capability to assign an organization to an approval in the role of "scope" of the approval.

In a number of STEP APs, constructs that require an approval are allowed only one approval assignment. This might lead to the misconception that only one person at one date/time can approve something. This is not the case. The approval constructs actually support an approval cycle (see Section 13.2.2). However, an approval may only need one signature corresponding to the simple basic approval scenario.

The level of an approval is understood to represent the aspect for which the approved object is endorsed. This level represents a “state” for which the approved object requires approval. The approval status indicates the level of acceptance given the object for the specified state.

NOTE - The entity product_definition exists to represent different views on a part version. Each view is characterized by a type and a life-cycle stage. Various part view “types” correspond to different states that a part assumes throughout its life cycle. The decision to represent the “state” of a part as a level of approval on a view definition or an entirely different view definition is dependent upon individual business processes. In the STEP PDM schema, different view definitions are typically characterized by different life-cycle stages such as ‘design’ and ‘manufacturing’. Approval levels are various “states” defined within a given life-cycle stage view, and are typically dependent upon the approval cycles within an individual business process. The “gates” associated with each defined “state” are described by the approval status values leading towards the status ‘approved’ indicating achievement of the particular level, or “state”.

**Date and Time**     
The PDM Schema provides mechanisms for assignment of date and time to product data aiming at characterizing when some event or fact occurred. The specification of time is optional, i.e., in many cases only date is required. The applied_date_assignment entity allows for association of date with product data. The purpose of this association is specified by an instance of the entity date_role. As described later in this section, the PDM Schema supports a similar structure for concurrent assignment of date and time.

Dates are represented using the calendar_date entity, i.e., by specifying year, month and day. Time is unambiguously represented using the local_time entity, as it enforces the specification of the time zone, i.e., the offset to the coordinated universal time.

**Event Reference**    
In the PDM Schema, events are characterized by instances of the event_occurrence entity or its subtype relative_event_occurrence.

**Security Classification**    
A security classification is the level of confidentiality that is required in order to protect product data against unauthorized usage.

**Certification**    
The PDM Schema supports the assignment of certification information to parts, component usages and relationships between part versions. The key entity used for this purpose is certification. In the PDM Schema primarily the certification of supplied parts is seen as a use case for certification. Thus the assignment of certification information is restricted to instances of product_definition_formation_relationship that model a 'supplied part'-relationship.


## Topics

### 13.1 Organization and Person

- ``organizations(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``items(assignedTo:)-(apPDM.eORGANIZATION.PRef?)``
- ``organizations(assignedTo:)-(apPDM.sORGANIZATION_ITEM?)``

### 13.2 Approval

- ``approvals(on:)-(apPDM.sAPPROVAL_ITEM?)``
- ``responsibles(for:)-(apPDM.eAPPROVAL.PRef?)``
- ``approvalDates(for:)-(apPDM.eAPPROVAL.PRef?)``
- ``relatedApprovals(to:)-(apPDM.eAPPROVAL.PRef?)``
- ``relatingApprovals(to:)-(apPDM.eAPPROVAL.PRef?)``

### 13.3 Dates, Times, and Event References
### 13.4 Security classification

- ``securityClassifications(for:)-(apPDM.sSECURITY_CLASSIFICATION_ITEM?)``

### 13.5 Certification

- ``certifications(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``certifiedItems(by:)-(apPDM.eCERTIFICATION.PRef?)``
- ``certifications(for:)-(apPDM.sCERTIFIED_ITEM?)``



