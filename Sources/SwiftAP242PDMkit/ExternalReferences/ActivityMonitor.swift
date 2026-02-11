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
  /// A progress and event monitor for loading operations involving external references.
  /// 
  /// `ActivityMonitor` is a subclass of `P21Decode.ActivityMonitor` and is designed to support the
  /// observation and tracking of the loading process for an `ExternalReference`. It provides hooks
  /// to notify clients when loading starts, completes, or when child references are identified.
  /// 
  /// This class is suitable for concurrent loading scenarios, and is marked as `Sendable` (unchecked)
  /// to allow use in Swift concurrency contexts. Subclasses may override notification methods to
  /// implement custom monitoring or reporting behaviors.
  /// 
  /// - Note: Instances of `ActivityMonitor` are initialized with a target `ExternalReference` and a
  ///   flag indicating whether the operation is concurrent.
  /// 
  /// - Important: For thread safety, ensure any overridden methods are safe to call from concurrent contexts.
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
