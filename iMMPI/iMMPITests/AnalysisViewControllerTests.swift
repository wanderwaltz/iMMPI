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
        var receivedSender: UIViewController? = nil
        var receivedOrigin: UIBarButtonItem? = nil

        let expectedSender = controller
        let expectedOrigin = controller.navigationItem.rightBarButtonItem

        router._displayAnalysisOptions = { sender, origin in
            receivedSender = sender
            receivedOrigin = origin
        }

        controller.navigationItem.rightBarButtonItem?.click()
        XCTAssertTrue(receivedSender === expectedSender)
        XCTAssertTrue(receivedOrigin === expectedOrigin)
    }
}
