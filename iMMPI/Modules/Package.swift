// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Modules",
    products: [
        .library(
            name: "Modules",
            targets: [
                "EmailComposing",
            ]
        ),

        .library(
            name: "UnitTestingSupport",
            targets: [
                "UnitTestingSupport",
            ]
        )
    ],
    dependencies: [],
    targets: [
        .target(name: "Utils"),

        .target(
            name: "UnitTestingSupport",
            dependencies: [
                "Utils",
            ]
        ),

        .target(
            name: "EmailComposing",
            dependencies: [
                "Utils",
            ]
        ),
        .testTarget(
            name: "EmailComposingTests",
            dependencies: [
                "EmailComposing",
                "UnitTestingSupport",
                "Utils",
            ]
        )
    ]
)
