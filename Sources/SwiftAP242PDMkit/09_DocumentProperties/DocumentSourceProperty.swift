//
//  DocumentSourceProperty.swift
//  
//
//  Created by Yoshida on 2021/08/24.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore




/// obtains the source properties of a given document file (9.6.2)
/// - Parameter documentFile: document file
/// - Returns: source properties
/// 
/// # Reference
/// 9.6 Document source property;
/// 9.6.2 applied_external_identification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func sourceProperties(
	of documentFile: apPDM.eDOCUMENT_FILE.PRef?
) -> Set<apPDM.eAPPLIED_EXTERNAL_IDENTIFICATION_ASSIGNMENT.PRef>
{
	if let extItem = apPDM.sEXTERNAL_IDENTIFICATION_ITEM(documentFile) {
		return sourceProperties(of: extItem)
	}
	return []
}

/// obtains the source properties of a given product definition (9.6.2)
/// - Parameter productDefinition: product definition
/// - Returns: source properties
/// 
/// # Reference
/// 9.6 Document source property;
/// 9.6.2 applied_external_identification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func sourceProperties(
	of productDefinition: apPDM.ePRODUCT_DEFINITION.PRef?
)-> Set<apPDM.eAPPLIED_EXTERNAL_IDENTIFICATION_ASSIGNMENT.PRef>
{
	if let extItem = apPDM.sEXTERNAL_IDENTIFICATION_ITEM(productDefinition) {
		return sourceProperties(of: extItem)
	}
	return []
}

/// obtains the source properties of a generic external identification item (9.6.2)
/// - Parameter externalIdentificationItem: external identification item
/// - Returns: source properties
/// 
/// # Reference
/// 9.6 Document source property;
/// 9.6.2 applied_external_identification_assignment;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public func sourceProperties(
	of externalIdentificationItem: apPDM.sEXTERNAL_IDENTIFICATION_ITEM?
)-> Set<apPDM.eAPPLIED_EXTERNAL_IDENTIFICATION_ASSIGNMENT.PRef>
{
	let usedin = SDAI.USEDIN(
		T: externalIdentificationItem, 
		ROLE: \apPDM.eAPPLIED_EXTERNAL_IDENTIFICATION_ASSIGNMENT.ITEMS) 
	return Set(usedin)
}



/// obtains the file location info of a given document file, according to the recommended practice (RPER 2.1)
/// - Parameter documentFile: document file
/// - Returns: file location info
/// 
/// # Reference
/// 2.1 Placement of the file name;
/// 
/// Recommended Practices for External References; 
/// with References to the PDM Schema Usage Guide; 
/// Release 2.1, Jan. 19, 2005;
/// PDM Implementor Forum
///
public func fileLocations(
	of documentFile: apPDM.eDOCUMENT_FILE.PRef?,
  base: URL,
  parent: DocumentSourceProperty,
  resolver: ExternalReferenceLoader.ForeignReferenceResolver?
) -> [DocumentSourceProperty]
{
	let AEIAs = sourceProperties(of: documentFile)
	if !AEIAs.isEmpty {
		var fileIds:[DocumentSourceProperty] = []
		for AEIA in AEIAs {
			guard let AEIA_ = AEIA.eval else { continue }

      let fileId: DocumentSourceProperty

      if AEIA_.ASSIGNED_ID.asSwiftType.isEmpty {
        guard let fileName = AEIA_.SOURCE.SOURCE_ID?.stringValue?.asSwiftType
        else { continue }
        let mechanism = AEIA_.ROLE.NAME?.asSwiftType

        if let resolver {
          fileId = resolver.resolveExternalReference(
            fileName: fileName,
            path: nil,
            mechanism: mechanism,
            base: base,
            parent: parent)
        }
        else {
          fileId = DocumentSourceProperty(
            fileName: fileName,
            path: nil,
            mechanism: mechanism,
            base: base)
        }

//        fileIds.append(fileId)
			}
			else {
        let fileName = AEIA_.ASSIGNED_ID.asSwiftType
        let path = AEIA_.SOURCE.SOURCE_ID?.stringValue?.asSwiftType
        let mechanism = AEIA_.ROLE.NAME?.asSwiftType

//        let fileId: DocumentSourceProperty
        if let resolver {
          fileId = resolver.resolveExternalReference(
            fileName: fileName,
            path: path,
            mechanism: mechanism,
            base: base,
            parent: parent)
        }
        else {
          fileId = DocumentSourceProperty(
            fileName: fileName,
            path: path,
            mechanism: mechanism,
            base: base)
        }

      }
      guard fileId.targetURL != nil else { continue }
      fileIds.append(fileId)
		}
		return fileIds
	}
	else {
    guard let fileName = documentFile?.ID?.asSwiftType
    else { return [] }

    let fileId: DocumentSourceProperty
    if let resolver {
      fileId = resolver.resolveExternalReference(
        fileName: fileName,
        path: nil,
        mechanism: nil,
        base: base,
        parent: parent)
    }
    else {
      fileId = DocumentSourceProperty(
        fileName: fileName,
        path: nil,
        mechanism: nil,
        base: base)
    }
    guard fileId.targetURL != nil else { return [] }
		return [fileId]
	}
}

/// specification of location of a document object (9.6)
///
/// # Reference
/// 9.6 Document source property;
/// 
/// Usage Guide for the STEP PDM Schema V1.2;
/// Release 4.3, Jan. 2002;
/// PDM Implementor Forum
///
public struct DocumentSourceProperty: Hashable, Sendable
{
  public let baseURL: URL
  public let targetURL: URL?
	public let fileName: String
  public var path: String? {
    targetURL?.deletingLastPathComponent().path
  }
	public let mechanism: String?

  public init(
    fileName: String,
    path: String?,
    mechanism: String?,
    base: URL)
  {
		self.fileName = fileName
		self.mechanism = mechanism
    self.baseURL = base

    if let path {
      self.targetURL = URL(
        string: path + "/" + fileName,
        relativeTo: base)
    }
    else {
      self.targetURL = base.appending(component: fileName, directoryHint: .notDirectory)
    }
	}
  
  public init(url: URL, base: URL) {
    self.fileName = url.lastPathComponent
    self.mechanism = "URL"
    self.baseURL = base

    self.targetURL = URL(string: url.path, relativeTo: base)

  }

}


/// obtains the document format of a given document file (RPER 2.3)
/// - Parameter documentFile: document file
/// - Throws: multiplePropertyDefinitions, multiplePropertyRepresentations
/// - Returns: document format property representation
/// 
/// # Reference
/// 2.3 Document Format Properties
/// 
/// Recommended Practices for External References; 
/// with References to the PDM Schema Usage Guide; 
/// Release 2.1, Jan. 19, 2005;
/// PDM Implementor Forum
///
public func documentFormat(
	of documentFile: apPDM.eDOCUMENT_FILE.PRef?
) throws -> apPDM.eREPRESENTATION.PRef?
{
	let documentProperties = properties(of: documentFile)
		.filter{ $0.NAME == "document property" }
	
	guard documentProperties.count <= 1 else {
		throw PDMkitError.multiplePropertyDefinitions(documentProperties)
	}
	
	let rep = try representation(of: documentProperties.first)
	return rep
}
