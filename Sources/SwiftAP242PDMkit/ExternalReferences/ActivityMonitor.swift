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
	open class ActivityMonitor: P21Decode.ActivityMonitor {
		open func startedLoading(externalReference: ExternalReference) {}
		open func completedLoading(externalReference: ExternalReference) {}
		open func identified(externalReferences: [ExternalReference], originatedFrom upstream: ExternalReference) {}
	}
}
