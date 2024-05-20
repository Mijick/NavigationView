// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MijickNavigationView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MijickNavigationView", targets: ["MijickNavigationView"]),
    ],
    targets: [
        .target(name: "MijickNavigationView", dependencies: [], path: "Sources")
    ]
)
