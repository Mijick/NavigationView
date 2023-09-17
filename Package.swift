// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Navigattie",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MijickNavigattie", targets: ["MijickNavigattie"]),
    ],
    targets: [
        .target(name: "MijickNavigattie", dependencies: [], path: "Sources")
    ]
)
