import XCTest
@testable import iMMPI

class MMPIViewControllersFactoryTestCase: XCTestCase {
    var storage: StubRecordStorage!
    var trashStorage: StubRecordStorage!

    var viewControllersFactory: MMPIViewControllersFactory!

    override func setUp() {
        super.setUp()

        if storage == nil {
            storage = StubRecordStorage.default
        }

        if trashStorage == nil {
            trashStorage = StubRecordStorage.trash
        }

        viewControllersFactory = MMPIViewControllersFactory(
            storage: storage,
            trashStorage: trashStorage,
            analysisSettings: ValidatingAnalysisSettings(UserDefaultsAnalysisSettings()),
            analysisOptionsDelegate: MMPIViewControllersFactory.AnalysisOptionsDelegate(),
            editingDelegate: MMPIViewControllersFactory.EditingDelegate(storage: storage),
            mailComposerDelegate: MMPIViewControllersFactory.MailComposerDelegate(),
            reportPrintingDelegate: MMPIViewControllersFactory.ReportPrintingDelegate(),
            screenDescriptorSerialization: ScreenDescriptorSerialization()
        )

        MMPIViewControllerRestoration.sharedViewControllerFactory = viewControllersFactory
    }
}
