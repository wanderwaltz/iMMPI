import XCTest
@testable import iMMPI

final class MMPIRouterAnalysisOptionsDelegateTests: XCTestCase {
    var delegate: MMPIRouter.AnalysisOptionsDelegate!

    override func setUp() {
        super.setUp()
        delegate = MMPIRouter.AnalysisOptionsDelegate()
    }

    func testThat__it_sends_notification_when_analysis_settings_change() {
        expectation(forNotification: Notification.Name.analysisSettingsChanged, object: nil)
        delegate.analysisOptionsViewControllerSettingsChanged(AnalysisOptionsViewController(style: .plain))
        waitForExpectations(timeout: 0.125)
    }
}
