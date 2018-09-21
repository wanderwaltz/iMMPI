import XCTest
@testable import iMMPI

final class MMPIViewControllerRestorationAllRecordsTests: MMPIViewControllersFactoryTestCase {
    var allRecordsVC: RecordsListViewController!

    override func setUp() {
        super.setUp()
        allRecordsVC = MMPIViewControllerRestoration.viewController(
            withRestorationIdentifierPath: [
                ScreenDescriptorSerialization.RestorationIdentifier.allRecords
            ],
            coder: NSCoder()
        ) as? RecordsListViewController
    }

    func testThat__all_records_view_controller_is_records_list_view_controller() {
        XCTAssertNotNil(allRecordsVC)
    }

    func testThat__all_records_view_controller_has_non_nil_restoration_identifier() {
        XCTAssertNotNil(allRecordsVC.restorationIdentifier)
    }

    func testThat__all_records_view_controller_has_known_restoration_class() {
        XCTAssertTrue(allRecordsVC.restorationClass === MMPIViewControllerRestoration.self)
    }

    func testThat__all_records_view_controller_has_non_nil_view_model() {
        XCTAssertNotNil(allRecordsVC.viewModel)
    }

    func testThat__all_records_view_controller_provides_index() {
        XCTAssertEqual(allRecordsVC.viewModel?.shouldProvideIndex, true)
    }

    func testThat__all_records_view_controller_has_left_navigation_bar_button() {
        XCTAssertNotNil(allRecordsVC.navigationItem.leftBarButtonItem)
    }

    func testThat__all_records_view_controller_has_right_navigation_bar_button() {
        XCTAssertNotNil(allRecordsVC.navigationItem.rightBarButtonItem)
    }

    func testThat__all_records_view_controller_has_known_title() {
        XCTAssertEqual(allRecordsVC.title, Strings.Screen.records)
    }
}

