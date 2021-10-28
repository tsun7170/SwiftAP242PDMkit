//
//  File.swift
//  
//
//  Created by Yoshida on 2021/10/25.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore
import SwiftSDAIap242


extension ExternalReferenceLoader {
	public class ExternalReference: SDAI.Object {
		public var documentFile: ap242.eDOCUMENT_FILE? = nil
		public var sourceProperties: [DocumentSourceProperty]
		public var level: Int
		public var upStream: ExternalReference? = nil
		public var status: LoadingStatus = .notLoadedYet
		
		public private(set) lazy var name: String = {
			self.sourceProperties[0].fileName	
		}()
		
		public var exchangeStructure: P21Decode.ExchangeStructure? {
			switch self.status {
				case .loaded(let exchange):
					return exchange
				default:
					return nil
			}
		}
		
		public init(asTopLevel url: URL) {
			self.sourceProperties = [DocumentSourceProperty(url: url)]
			level = 0
		}
		
		public init(upStream: ExternalReference, documentFile: ap242.eDOCUMENT_FILE, resolver: ForeignReferenceResolver) {
			let docSources = fileLocations(of: documentFile)
			let parentSource = upStream.sourceProperties[0]
			self.sourceProperties = docSources
				.map{ resolver.fixupExternalReference($0, parent: parentSource) }
			self.upStream = upStream
			self.level = upStream.level + 1
		}
	}
}
