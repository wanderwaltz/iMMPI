import XCTest
@testable import iMMPI

final class MMPIRouterAnalysisOptionsDelegateTests: XCTestCase {
    var delegate: MMPIRouter.AnalysisOptionsDelegate!

    override func setUp() {
        super.setUp()
        delegate = MMPIRouter.AnalysisOptionsDelegate()
    }

    func testThat__it_sends_notification_when_analysis_settings_change() {
        expectation(forNotification: Notification.Name.analysisSettingsChanged.rawValue, object: nil)
        delegate.analysisOptionsViewControllerSettingsChanged(AnalysisOptionsViewController())
        waitForExpectations(timeout: 0.125)
    }
}
