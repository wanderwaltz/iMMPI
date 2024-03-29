// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Modules",
            targets: [
                "Serialization",
                "MMPIRouting",
                "MMPIViewControllersFactoryProduction",
                "MMPIRoutingProduction",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.0")),
    ],
    targets: [
        .target(
            name: "UnitTestingSupport"
        ),

        .target(name: "Utils"),
        .testTarget(
            name: "UtilsTests",
            dependencies: [
                "Utils",
                "HTMLComposing",
            ]
        ),

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
                "DocxComposing",
                "Localization",
                "Formatters",
            ],
            resources: [
                .copy("Resources/html.report.css"),
                .copy("Resources/ReportTemplate.bundle"),
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

        .target(
            name: "UITableViewModels",
            dependencies: [
                "Utils"
            ]
        ),
        .testTarget(
            name: "UITableViewModelsTests",
            dependencies: [
                "UITableViewModels",
            ]
        ),

        .target(
            name: "UIReusableViews",
            dependencies: [
                "Utils",
            ]
        ),
        .testTarget(
            name: "UIReusableViewsTests",
            dependencies: [
                "UIReusableViews",
                "Utils",
            ],
            resources: [
                .process("Resources"),
            ]
        ),

        .target(
            name: "MMPIUI",
            dependencies: [
                "DataModel",
                "UITableViewModels",
            ]
        ),

        .target(
            name: "MMPIUITableViewCells",
            dependencies: [
                "DataModel",
                "Analysis",
                "AnalysisReports",
                "AnalysisSettings",
                "MMPIUI",
                "Formatters",
                "UIReusableViews",
            ]
        ),

        .target(
            name: "MMPIRouting",
            dependencies: [
                "DataModel",
                "Analysis",
                "AnalysisReports",
                "HTMLComposing",
                "EmailComposing",
                "UITableViewModels",
            ]
        ),
        .target(
            name: "MMPIRoutingMocks",
            dependencies: [
                "MMPIRouting",
            ]
        ),
        .testTarget(
            name: "MMPIRoutingTests",
            dependencies: [
                "MMPIRouting",
                "MMPIRoutingMocks",
                "MMPIRoutingProduction",
            ]
        ),

        .target(
            name: "MMPIDatePickerUI"
        ),

        .target(
            name: "MMPIRecordEditorUI",
            dependencies: [
                "DataModel",
                "Localization",
                "Formatters",
                "MMPIUITableViewCells",
                "MMPIRouting",
                "MMPIDatePickerUI",
            ]
        ),

        .target(
            name: "MMPIRecordsListUI",
            dependencies: [
                "Utils",
                "UITableViewModels",
                "UIReusableViews",
                "DataModel",
                "Localization",
                "Formatters",
                "MMPIUI",
                "MMPIRouting",
            ]
        ),
        .testTarget(
            name: "MMPIRecordsListUITests",
            dependencies: [
                "MMPIRecordsListUI",
            ]
        ),

        .target(
            name: "MMPITestAnswersUI",
            dependencies: [
                "DataModel",
                "Localization",
                "MMPIUITableViewCells",
                "MMPIRouting",
            ]
        ),

        .target(
            name: "MMPIAnalysisUI",
            dependencies: [
                "Utils",
                "UITableViewModels",
                "UIReusableViews",
                "Localization",
                "HTMLComposing",
                "DataModel",
                "Analysis",
                "AnalysisReports",
                "MMPIRouting",
                "MMPIUITableViewCells",
            ]
        ),
        .testTarget(
            name: "MMPIAnalysisUITests",
            dependencies: [
                "MMPIAnalysisUI",
                "UnitTestingSupport",
                "MMPIRoutingMocks",
            ]
        ),

        .target(
            name: "MMPIScaleDetailsUI",
            dependencies: [
                "Analysis",
                "Localization",
                "MMPIRouting",
            ]
        ),

        .target(
            name: "MMPIViewControllersFactory",
            dependencies: [
                "EmailComposing",
                "MMPIRouting",
                "MMPIRecordEditorUI",
                "MMPIRecordsListUI",
                "MMPITestAnswersUI",
                "MMPIAnalysisUI",
                "MMPIScaleDetailsUI",
            ]
        ),

        .target(
            name: "MMPIViewControllersFactoryProduction",
            dependencies: [
                "MMPIViewControllersFactory",
            ]
        ),

        .target(
            name: "MMPISoundPlayer",
            resources: [
                .copy("Resources/button_tap1.wav"),
                .copy("Resources/button_tap2.wav"),
            ]
        ),

        .target(
            name: "MMPIRoutingProduction",
            dependencies: [
                "MMPIRouting",
                "MMPIViewControllersFactory",
                "MMPISoundPlayer",
            ]
        ),

        .target(
            name: "DocxComposing",
            dependencies: [
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
            ]
        )
    ]
)
