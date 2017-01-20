import XCTest
@testable import iMMPI

final class AnalysisViewControllerTests: XCTestCase {
    var controller: AnalysisViewController!
    var router: StubRouter!

    override func setUp() {
        super.setUp()
        controller = AnalysisViewController(style: .plain)
        router = StubRouter()
        controller.router = router
    }

    func testThat__it_has_left_bar_button_item_by_default() {
        XCTAssertNotNil(controller.navigationItem.leftBarButtonItem)
    }


    func testThat__it_has_right_bar_button_item_by_default() {
        XCTAssertNotNil(controller.navigationItem.rightBarButtonItem)
    }


    func testThat__left_bar_button_item__title_is_answers() {
        XCTAssertEqual(controller.navigationItem.leftBarButtonItem?.title, Strings.answers)
    }


    func testThat__left_bar_button_item__does_nothing_without_a_record() {
        var called = false
        router._displayAnswersReview = { _ in called = true }
        controller.navigationItem.leftBarButtonItem?.click()
        XCTAssertFalse(called)
    }


    func testThat__left_bar_button_item__displays_answers_review_using_router_if_record_is_present() {
        var receivedRecord: TestRecordProtocol? = nil
        var receivedSender: UIViewController? = nil

        let expectedRecord = TestRecord()
        let expectedSender = controller

        router._displayAnswersReview = { record, sender in
            receivedRecord = record
            receivedSender = sender
        }

        controller.record = expectedRecord
        controller.navigationItem.leftBarButtonItem?.click()
        XCTAssertTrue(receivedRecord === expectedRecord)
        XCTAssertTrue(receivedSender === expectedSender)
    }


    func testThat__right_bar_button_item__displays_analysis_options() {
        var receivedContext: AnalysisMenuActionContext? = nil
        var receivedSender: UIViewController? = nil

        let expectedRecord = TestRecord()
        let expectedAnalyser = Analyzer()
        let expectedSender = controller

        router._displayAnalysisOptions = { context, sender in
            receivedContext = context
            receivedSender = sender
        }

        controller.record = expectedRecord
        controller.analyser = expectedAnalyser

        controller.navigationItem.rightBarButtonItem?.click()

        XCTAssertTrue(receivedSender === expectedSender)
        XCTAssertTrue(receivedContext!.record === expectedRecord)
        XCTAssertTrue(receivedContext!.analyser === expectedAnalyser)
        XCTAssertTrue(receivedContext!.router === router)
    }


    func testThat__if_it_has_an_analyser_it_reloads_data_when_receiving_analysis_settings_change_notification() {
        controller.analyser = Analyzer()
        controller.tableView = CheckReloadTataTableView()
        NotificationCenter.default.post(name: .analysisSettingsChanged, object: nil)
        XCTAssertEqual((controller.tableView as! CheckReloadTataTableView).reloadDataCallsCount, 1)
    }


    func testThat__with_nil_analyser_it_does_not_reload_data_when_receiving_analysis_settings_change_notification() {
        controller.tableView = CheckReloadTataTableView()
        NotificationCenter.default.post(name: .analysisSettingsChanged, object: nil)
        XCTAssertEqual((controller.tableView as! CheckReloadTataTableView).reloadDataCallsCount, 0)
    }


    class CheckReloadTataTableView: UITableView {
        var reloadDataCallsCount = 0

        override func reloadData() {
            reloadDataCallsCount += 1
        }
    }
}
