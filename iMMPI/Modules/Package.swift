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
                "UITableViewModels",
                "UIReusableViews",
                "MMPIUI",
                "MMPIUITableViewCells",
                "MMPIRouting",
                "MMPIRecordEditorUI",
                "MMPIRecordsListUI",
                "MMPITestAnswersUI",
                "MMPIAnalysisUI",
                "MMPIViewControllersFactoryProduction",
                "MMPIRoutingProduction",
            ]
        ),
    ],
    dependencies: [],
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
                "Localization",
                "Formatters",
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
            name: "MMPIViewControllersFactory",
            dependencies: [
                "EmailComposing",
                "MMPIRouting",
                "MMPIRecordEditorUI",
                "MMPIRecordsListUI",
                "MMPITestAnswersUI",
                "MMPIAnalysisUI",
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
    ]
)
