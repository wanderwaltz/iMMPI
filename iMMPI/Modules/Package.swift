// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Modules",
    products: [
        .library(
            name: "Modules",
            targets: [
                "Formatters",
                "EmailComposing",
                "HTMLComposing",
                "DataModel",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .target(name: "Utils"),

        .target(name: "Formatters"),
        .testTarget(
            name: "FormattersTests",
            dependencies: [
                "Formatters"
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
                "Utils",
                "EmailComposing"
            ]
        ),

        .target(
            name: "HTMLComposing"
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
