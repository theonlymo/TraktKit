// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TraktKit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "TraktKit",
            targets: ["TraktKit"]),
    ],
    targets: [
        .target(
            name: "TraktKit",
            dependencies: [],
            path: "Common"
            ),
        .testTarget(
            name: "TraktKitTests",
            dependencies: ["TraktKit"],
            resources: [
                .process("Models")
            ]
        ),
    ],
    swiftLanguageModes: [.version("6.0")]
)
