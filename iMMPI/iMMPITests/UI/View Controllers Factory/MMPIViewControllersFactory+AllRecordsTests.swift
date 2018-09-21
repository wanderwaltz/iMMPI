import XCTest
@testable import iMMPI

final class MMPIViewControllersFactoryAllRecordsTests: MMPIViewControllersFactoryTestCase {
    func testThat__all_records_view_controller_is_records_list_view_controller() {
        let allRecordsVC = viewControllersFactory.makeViewController(for: .allRecords)
        XCTAssertTrue(allRecordsVC is RecordsListViewController)
    }

    func testThat__all_records_view_controller_has_non_nil_restoration_identifier() {
        let allRecordsVC = viewControllersFactory.makeViewController(for: .allRecords)
        XCTAssertNotNil(allRecordsVC.restorationIdentifier)
    }

    func testThat__all_records_view_controller_has_known_restoration_class() {
        let allRecordsVC = viewControllersFactory.makeViewController(for: .allRecords)
        XCTAssertTrue(allRecordsVC.restorationClass === MMPIViewControllerRestoration.self)
    }

    func testThat__all_records_view_controller_has_non_nil_view_model() {
        let allRecordsVC = viewControllersFactory.makeViewController(for: .allRecords) as! RecordsListViewController
        XCTAssertNotNil(allRecordsVC.viewModel)
    }

    func testThat__all_records_view_controller_provides_index() {
        let allRecordsVC = viewControllersFactory.makeViewController(for: .allRecords) as! RecordsListViewController
        XCTAssertEqual(allRecordsVC.viewModel?.shouldProvideIndex, true)
    }

    func testThat__all_records_view_controller_has_left_navigation_bar_button() {
        let allRecordsVC = viewControllersFactory.makeViewController(for: .allRecords)
        XCTAssertNotNil(allRecordsVC.navigationItem.leftBarButtonItem)
    }

    func testThat__all_records_view_controller_has_right_navigation_bar_button() {
        let allRecordsVC = viewControllersFactory.makeViewController(for: .allRecords)
        XCTAssertNotNil(allRecordsVC.navigationItem.rightBarButtonItem)
    }

    func testThat__all_records_view_controller_has_known_title() {
        let allRecordsVC = viewControllersFactory.makeViewController(for: .allRecords)
        XCTAssertEqual(allRecordsVC.title, Strings.Screen.records)
    }
}
