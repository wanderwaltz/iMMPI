import XCTest
@testable import iMMPI

class MMPIViewControllersFactoryTestCase: XCTestCase {
    var storage: RecordStorage!
    var trashStorage: RecordStorage!

    var viewControllersFactory: MMPIViewControllersFactory!

    override func setUp() {
        super.setUp()

        storage = StubRecordStorage.default
        trashStorage = StubRecordStorage.trash

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
    }
}
