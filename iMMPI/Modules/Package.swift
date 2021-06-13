// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Modules",
    products: [
        .library(
            name: "Modules",
            targets: [
                "EmailComposing",
                "DataModel",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .target(name: "Utils"),

        .target(
            name: "EmailComposing",
            dependencies: [
                "Utils",
            ]
        ),
        .testTarget(
            name: "EmailComposingTests",
            dependencies: [
                "Utils",
                "EmailComposing"
            ]
        ),

        .target(
            name: "Localization"
        ),

        .target(
            name: "DataModel",
            dependencies: [
                "Localization",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "DataModelTests",
            dependencies: [
                "DataModel"
            ],
            resources: [
                .process("Resources"),
            ]
        )
    ]
)
