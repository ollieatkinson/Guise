// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "public-api-generator",
    dependencies: [
         .package(url: "https://github.com/Carthage/Commandant.git", from: "0.13.0"),
         .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.21.1"),
    ],
    targets: [
        .target(name: "public-api-generator", dependencies: [
          "Commandant",
          "SourceKittenFramework" 
        ]),
    ]
)
