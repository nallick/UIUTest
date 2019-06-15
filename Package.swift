// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "UIUTest",
	platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "UIUTest",
            targets: ["UIUTest_ObjC", "UIUTest"]),
    ],
    dependencies: [
    ],
    targets: [
		.target(
			name: "UIUTest_ObjC",
			dependencies: [],
			path: "Sources/Obj-C Support"),
		.target(
			name: "UIUTest",
			dependencies: ["UIUTest_ObjC"],
			path: "Sources/Swift"),
    ]
)
