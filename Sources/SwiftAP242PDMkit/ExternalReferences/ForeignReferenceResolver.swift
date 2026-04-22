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
    /// An enumeration describing the disposition or handling recommendation
    /// for a given external reference encountered during Part 21 decoding.
    ///
    /// - `load`:            Indicates that the external reference is recognized and should be loaded.
    /// - `suspendLoading`:  Indicates that loading the external reference should be deferred or suspended.
    /// - `referenceUnknown`:Indicates that the external reference is unrecognized, unsupported, or cannot be processed.
    ///
    /// This enumeration is used by the foreign reference resolver to determine how to handle
    /// different types of external references, based on their mechanism and content.
		public enum ExternalReferenceDisposition {
			case load
			case suspendLoading
			case referenceUnknown
		}

    open func resolveExternalReference(
      fileName: String,
      path: String?,
      mechanism: String?,
      base: URL,
      parent: DocumentSourceProperty
    ) -> DocumentSourceProperty
    {
      let resolvedPath: String?
      if let path, !path.isEmpty {
        resolvedPath = path
      }
      else if let path = parent.path {
        resolvedPath = path
      }
      else {
        resolvedPath = nil
      }

      let resolvedMechanism: String?
      if let mechanism, !mechanism.isEmpty {
        resolvedMechanism = mechanism
      }
      else if let mechanism = parent.mechanism {
        resolvedMechanism = mechanism
      }
      else {
        resolvedMechanism = nil
      }

      return DocumentSourceProperty(
        fileName: fileName,
        path: resolvedPath,
        mechanism: resolvedMechanism,
        base: base)
    }


    /// Determines the disposition of a given external reference, indicating
    /// whether it should be loaded, suspended, or is unknown.
    ///
    /// - Parameter externalReference: The external reference to evaluate.
    /// - Returns: An `ExternalReferenceDisposition` value indicating the recommended action:
    ///   - `.load`: The reference should be loaded (supported mechanisms with recognized file extensions).
    ///   - `.suspendLoading`: Loading should be suspended (not used in the default implementation).
    ///   - `.referenceUnknown`: The reference mechanism or file type is unrecognized.
    ///
    /// The default implementation recognizes external references with mechanisms "URL"
    /// or "external document id and location", and only files with ".STP" or ".P21"
    /// (case-insensitive) extensions. Other references are treated as unknown.
		open func disposition(
			of externalReference: DocumentSourceProperty
		) -> ExternalReferenceDisposition
		{
			guard externalReference.mechanism == "URL" ||
						externalReference.mechanism == "external document id and location"
			else { return .referenceUnknown }

			return .load
		}
		
    /// Loads a character stream from the specified external reference.
    ///
    /// - Parameter externalReference: The external reference describing the resource to load.
    /// - Returns: An optional `P21Decode.AnyCharacterStream` obtained from the referenced file using UTF-8 decoding,
    ///            or `nil` if the file cannot be loaded or opened.
    ///
    /// The default implementation attempts to load the file specified by the path and file name
    /// in the `externalReference`, expecting it to be encoded in UTF-8. If the operation is successful,
    /// it returns a character stream suitable for use in Part 21 decoding; otherwise, it returns `nil`.
    ///
    /// - Note: Subclasses can override this method to implement custom loading logic,
    ///         such as supporting different encodings or alternate resource locations.
		open func characterSteam(
			from externalReference: DocumentSourceProperty
    ) -> P21Decode.AnyCharacterStream?
		{
      guard
        let url = externalReference.targetURL
      else { return nil }

			do {
				let source = try String(contentsOf: url, encoding: .utf8)
				let stream = source.makeIterator()
        return P21Decode.AnyCharacterStream(stream)
			}
			catch {
        SDAI.raiseErrorAndContinue(.SY_ERR, detail: "access denied on URL:\(url); error: \(error)")
				return nil
			}
		}
		
	}
}

