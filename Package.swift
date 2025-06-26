// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "networkframework",
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "networkframework",
            targets: ["networkframework"]
        ),
    ],
    targets: [
        .target(
            name: "networkframework",
            path: "networkframework",
            exclude: [
                "networkframework.docc"
            ]
        )
    ]
)
