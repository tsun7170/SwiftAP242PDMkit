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
		) -> AnyCharacterStream?
		{
			let url = URL(fileURLWithPath: (externalReference.path ?? ".") + "/" + externalReference.fileName)
			do {
				let source = try String(contentsOf: url, encoding: .utf8)
				let stream = source.makeIterator()
				return AnyCharacterStream(stream)
			}
			catch {
				return nil
			}
		}
		
	}
}

