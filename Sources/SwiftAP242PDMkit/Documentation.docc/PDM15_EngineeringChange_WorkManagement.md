# §15 Engineering Change and Work Management

**Engineering Change and Work Management in the PDM Schema**

## Overview

The PDM Schema provides data structures for representation of the data used to manage the work being done during the engineering (release and change) process. The work management area contains the constructs to describe initial part design requirements and the change requirements and issues for revising part designs, as well as the proposed work and the directive for work to proceed in the development of these initial or modified part designs. The structures are based on three fundamental concepts: work request, work proposal, and work order.

Work request documents the need for a potential action such as creation of new functionality (release) or change of existing functionality, which may or may not ever be incorporated. If the request is incorporated, it is done through some action being taken on the request, which may result in the release of new functionality or a change to some existing functionality (or portions thereof). This action identifying the work to be done to address the request is formally directed by a work order.

All release and change proposals such as Engineering Change Proposals, Requests for Engineering Action, etc., are represented by the request for work portion of the work management data structure, i.e., the versioned_action_request and its related entity types. For a release or change proposal to be incorporated, there must be a definition of the actual work to be done. The work definition area includes the definition of work orders together with the activities that are directed by the work order.

In addition to the request for work and work definition structures, the PDM Schema provides the capability to represent project and contract related information, and to associate the work being done as part of the engineering process to the projects and contracts that control it.


## Topics

### 15.1 Request for Work

- ``workRequests(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``initialDesignWorkRequests(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``designChangeWorkRequests(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``potentialSolutions(for:)-(apPDM.eVERSIONED_ACTION_REQUEST.PRef?)``
- ``assignedChangeItems(to:)-(apPDM.eVERSIONED_ACTION_REQUEST.PRef?)``
- ``status(of:)-(apPDM.eVERSIONED_ACTION_REQUEST.PRef?)``
- ``workRequests(raisedAgainst:)-(apPDM.sACTION_REQUEST_ITEM?)``


### 15.2 Work Order and Work Definition
### 15.2.1 Work Order

- ``workOrders(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``workOrders(for:)-(apPDM.eVERSIONED_ACTION_REQUEST.PRef?)``
- ``directedAction(for:)-(apPDM.eACTION_DIRECTIVE.PRef?)``
- ``inputItems(for:)-(apPDM.eACTION.PRef?)``
- ``affectedItems(by:)-(apPDM.eACTION.PRef?)``



### 15.2.2 Activity decomposition

- ``status(for:)-(apPDM.eEXECUTED_ACTION.PRef?)``
- ``relatedActions(for:)-(apPDM.eACTION.PRef?)``
- ``relatingActions(for:)-(apPDM.eACTION.PRef?)``

### 15.3 Project Identification

- ``projects(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``projects(assignedTo:)-(apPDM.ePRODUCT_CONCEPT.PRef?)``
- ``projects(assignedTo:)-(apPDM.sPROJECT_ITEM?)``
- ``productConcepts(relatedTo:)-(apPDM.eORGANIZATIONAL_PROJECT.PRef?)``
- ``productData(relatedTo:)-(apPDM.eORGANIZATIONAL_PROJECT.PRef?)``
- ``relatedProjects(for:)-(apPDM.eORGANIZATIONAL_PROJECT.PRef?)``
- ``relatingProjects(for:)-(apPDM.eORGANIZATIONAL_PROJECT.PRef?)``


### 15.3.2 Assignment of activities to projects

- ``activities(assignedTo:)-(apPDM.eORGANIZATIONAL_PROJECT.PRef?)``


### 15.3.3 Start and end date and time of projects

- ``definedDateEvents(for:)-(apPDM.eORGANIZATIONAL_PROJECT.PRef?)``
- ``definedDateEvents(for:)-(apPDM.sDATE_ITEM?)``
- ``definedDateTimeEvents(for:)-(apPDM.eORGANIZATIONAL_PROJECT.PRef?)``
- ``definedDateTimeEvents(for:)-(apPDM.sDATE_TIME_ITEM?)``

### 15.4 Contract Identification

- ``contracts(in:)-(SDAIPopulationSchema.SchemaInstance)``
- ``contracts(binding:)-(apPDM.sCONTRACT_ITEM?)``
- ``boundItems(by:)-(apPDM.eCONTRACT.PRef?)``


