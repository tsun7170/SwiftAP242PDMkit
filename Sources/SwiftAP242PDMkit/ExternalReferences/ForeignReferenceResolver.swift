//
//  File.swift
//  
//
//  Created by Yoshida on 2021/10/25.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore

extension ExternalReferenceLoader {
	open class ForeignReferenceResolver: P21Decode.ForeignReferenceResolver {
		public enum ExternalReferenceDisposition {
			case load
			case suspendLoading
			case referenceUnknown
		}
		
		open func fixupExternalReference(_ externalReference: DocumentSourceProperty, parent: DocumentSourceProperty) -> DocumentSourceProperty {
			var result = externalReference
			
			result.path = parent.path
			
			if (result.mechanism ?? "") == "" {
				result.mechanism = parent.mechanism
			}
			
			return result
		}
		
		open func dispositon(of externalReference: DocumentSourceProperty) -> ExternalReferenceDisposition {
			guard externalReference.mechanism == "URL" else { return .referenceUnknown }
			
			let url = URL(fileURLWithPath: (externalReference.path ?? ".") + "/" + externalReference.fileName)
			let ext = url.pathExtension.uppercased()
			guard (ext == "STP")||(ext == "P21") else { return .referenceUnknown }
			
			return .load
		}
		
		open func characterSteam(from externalReference: DocumentSourceProperty) -> AnyCharacterStream? {
			let url = URL(fileURLWithPath: (externalReference.path ?? ".") + "/" + externalReference.fileName)
			do {
				let source = try String(contentsOf: url)
				let stream = source.makeIterator()
				return AnyCharacterStream(stream)
			}
			catch {
				return nil
			}
		}
		
	}
}
