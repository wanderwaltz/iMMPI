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
                "Serialization",
                "Analysis",
                "AnalysisReports",
                "AnalysisSettings",
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
        ),

        .target(
            name: "Serialization",
            dependencies: [
                "Formatters",
                "DataModel"
            ]
        ),

        .target(
            name: "AnalysisTestSamples",
            dependencies: [
                "Serialization"
            ],
            resources: [
                .process("Resources"),
            ]
        ),

        .testTarget(
            name: "SerializationTests",
            dependencies: [
                "Serialization",
                "AnalysisTestSamples",
            ]
        ),

        .target(
            name: "Analysis",
            dependencies: [
                "Utils",
                "DataModel",
            ]
        ),
        .testTarget(
            name: "AnalysisTests",
            dependencies: [
                "Analysis",
                "AnalysisTestSamples",
                "Serialization",
            ]
        ),

        .target(
            name: "AnalysisReports",
            dependencies: [
                "Analysis",
                "EmailComposing",
                "HTMLComposing",
                "Localization",
            ],
            resources: [
                .copy("Resources/html.report.css"),
            ]
        ),

        .target(
            name: "AnalysisSettings"
        ),
        .testTarget(
            name: "AnalysisSettingsTests",
            dependencies: [
                "AnalysisSettings"
            ]
        ),
    ]
)
