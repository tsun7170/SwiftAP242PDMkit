// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftAP242PDMkit",
	platforms: [
		.macOS(.v26)
	],
	products: [
		.library(
			name: "SwiftAP242PDMkit",
			targets: ["SwiftAP242PDMkit"]),
	],
	dependencies: [
		.package(url: "https://github.com/tsun7170/SwiftSDAIcore", from: "2.2.0"),
		.package(url: "https://github.com/tsun7170/SwiftSDAIap242ed4", from: "2.2.0"),
	],
	targets: [
		.target(
			name: "SwiftAP242PDMkit",
			dependencies: ["SwiftSDAIcore", "SwiftSDAIap242ed4"]),
		.testTarget(
			name: "SwiftAP242PDMkitTests",
			dependencies: ["SwiftAP242PDMkit"]),
	]
)


