//
//  ActivityMonitor.swift
//  
//
//  Created by Yoshida on 2021/10/25.
//  Copyright © 2021 Tsutomu Yoshida, Minokamo, Japan. All rights reserved.
//

import Foundation
import SwiftSDAIcore

extension ExternalReferenceLoader {
	open class ActivityMonitor: P21Decode.ActivityMonitor, @unchecked Sendable
	{
    public var externalReference: ExternalReference
    public let concurrently: Bool

    required public init(for externalReference: ExternalReference, concurrently: Bool) {
      self.externalReference = externalReference
      self.concurrently = concurrently
    }

		open func startedLoading(externalReference: ExternalReference) {
      self.externalReference = externalReference
    }

		open func completedLoading(externalReference: ExternalReference) {}

    open func identified(
      children: [ExternalReference],
      originatedFrom upstream: ExternalReference) {}
	}
}
