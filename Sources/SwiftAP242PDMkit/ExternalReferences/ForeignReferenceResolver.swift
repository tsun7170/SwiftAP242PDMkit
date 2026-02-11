//
//  ForeignReferenceResolver.swift
//  
//
//  Created by Yoshida on 2021/10/25.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore

extension ExternalReferenceLoader {
  /// An open class for resolving references to external resources
  /// during Part 21 (STEP file) decoding.
  ///
  /// Designed to be subclassed,
  /// it provides mechanisms for:
  ///
  /// - Fixing up or normalizing a given external reference with possible inheritance of information from a parent reference.
  /// - Determining the disposition of an external reference (e.g., whether it should be loaded, suspended, or is unknown).
  /// - Loading a character stream from an external reference for further decoding or parsing.
  ///
  /// You can override its methods to customize how external references are resolved,
  /// how file locations and mechanisms are interpreted, and how referenced data is loaded.
  ///
  /// This class is typically used as a plugin for `ExternalReferenceLoader`
  /// and is @unchecked Sendable for use in concurrent decoding workflows.
  ///
  /// - Note: The default implementation supports URL-based and "external document id and location"
  ///         mechanisms, and only recognizes files with "STP" or "P21" extensions.
	open class ForeignReferenceResolver: P21Decode.ForeignReferenceResolver,
                                       @unchecked Sendable
	{
		public enum ExternalReferenceDisposition {
			case load
			case suspendLoading
			case referenceUnknown
		}
		
		open func fixupExternalReference(
			_ externalReference: DocumentSourceProperty,
			parent: DocumentSourceProperty
		) -> DocumentSourceProperty
		{
      let fileName = externalReference.fileName

			let path = parent.path

      let mechanism: String?
			if (externalReference.mechanism ?? "") == "" {
				mechanism = parent.mechanism
			}
      else {
        mechanism = externalReference.mechanism
      }

			return DocumentSourceProperty(
        fileName: fileName,
        path: path,
        mechanism: mechanism)
		}
		
		open func disposition(
			of externalReference: DocumentSourceProperty
		) -> ExternalReferenceDisposition
		{
			guard externalReference.mechanism == "URL" ||
						externalReference.mechanism == "external document id and location"
			else { return .referenceUnknown }

			let url = URL(fileURLWithPath: (externalReference.path ?? ".") + "/" + externalReference.fileName)
			let ext = url.pathExtension.uppercased()
			guard (ext == "STP")||(ext == "P21") else { return .referenceUnknown }
			
			return .load
		}
		
		open func characterSteam(
			from externalReference: DocumentSourceProperty
    ) -> P21Decode.AnyCharacterStream?
		{
			let url = URL(fileURLWithPath: (externalReference.path ?? ".") + "/" + externalReference.fileName)
			do {
				let source = try String(contentsOf: url, encoding: .utf8)
				let stream = source.makeIterator()
        return P21Decode.AnyCharacterStream(stream)
			}
			catch {
				return nil
			}
		}
		
	}
}

