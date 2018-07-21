// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Guise",
    products: [
        .library(name: "GuiseFramework", targets: ["GuiseFramework"]),
        .executable(name: "guise", targets: ["guise"])
    ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.13.0"),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.21.1")
    ],
    targets: [
        .target(name: "guise", dependencies: [ "GuiseFramework" ]),
        .target(name: "GuiseFramework", dependencies: ["Commandant", "SourceKittenFramework"]),
        .testTarget(name: "GuiseFrameworkTests", dependencies: ["GuiseFramework"])
    ]
)
