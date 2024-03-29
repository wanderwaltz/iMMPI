import XCTest
import Localization
import DataModel
import MMPIRoutingMocks
import MMPIAnalysisUI
import MMPIRouting
import UnitTestingSupport

final class AnalysisViewControllerTests: XCTestCase {
    var controller: AnalysisViewController!
    var router: StubRouter!

    override func setUp() {
        super.setUp()
        controller = AnalysisViewController()
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
        XCTAssertEqual(controller.navigationItem.leftBarButtonItem?.title, Strings.Button.answers)
    }


    func testThat__left_bar_button_item__does_nothing_without_a_record() {
        var called = false
        router._displayAnswersReview = { _, _ in called = true }
        controller.navigationItem.leftBarButtonItem?.click()
        XCTAssertFalse(called)
    }


    func testThat__left_bar_button_item__displays_answers_review_using_router_if_record_is_present() {
        var receivedRecord: RecordProtocol? = nil
        var receivedSender: UIViewController? = nil

        let expectedRecord = Record()
        let expectedSender = controller

        router._displayAnswersReview = { record, sender in
            receivedRecord = record
            receivedSender = sender
        }

        controller.viewModel = AnalysisViewModel(records: [expectedRecord])
        controller.navigationItem.leftBarButtonItem?.click()
        XCTAssertTrue(receivedRecord === expectedRecord)
        XCTAssertTrue(receivedSender === expectedSender)
    }


    func testThat__right_bar_button_item__displays_analysis_options() {
        var receivedContext: AnalysisMenuActionContext? = nil
        var receivedSender: UIViewController? = nil

        let expectedRecord = Record()
        let expectedSender = controller

        router._displayAnalysisOptions = { context, sender in
            receivedContext = context
            receivedSender = sender
        }

        controller.viewModel = AnalysisViewModel(records: [expectedRecord])
        
        controller.navigationItem.rightBarButtonItem?.click()

        XCTAssertTrue(receivedSender === expectedSender)
        XCTAssertTrue(receivedContext!.record === expectedRecord)
        XCTAssertTrue(receivedContext!.router === router)
    }
}
