// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalizableParser",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.8.0"),
    ],
    targets: [
        .executableTarget(
            name: "LocalizableParser",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftCSV", package: "swiftcsv"),
            ]),
        .testTarget(
            name: "LocalizableParserTests",
            dependencies: ["LocalizableParser"]),
    ]
)
