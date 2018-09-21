import XCTest
@testable import iMMPI

final class AllRecordsViewControllerTests: RecordsListViewControllerTestCase {
    override var screenDescriptor: ScreenDescriptor {
        return .allRecords
    }

    func testThat__it_dislays_records_from_main_storage_grouped_by_name() {
        reloadViewControllerData()
        let allDisplayedNames = recordsListVC.tableView.visibleCells.compactMap({ $0.textLabel?.text })
        let uniqueNamesInStorage = Set(storage.all.map({ $0.person.name }))

        XCTAssertEqual(uniqueNamesInStorage.count, allDisplayedNames.count)
        XCTAssertEqual(uniqueNamesInStorage, Set(allDisplayedNames))
    }

    func testThat__id_does_not_display_records_from_trash_storage() {
        reloadViewControllerData()
        let allDisplayedNames = Set(recordsListVC.tableView.visibleCells.compactMap({ $0.textLabel?.text }))
        let uniqueNamesInTrashStorage = Set(trashStorage.all.map({ $0.person.name }))

        XCTAssertTrue(allDisplayedNames.intersection(uniqueNamesInTrashStorage).isEmpty)
    }

    func testThat__its_left_navigation_bar_button_shows_trash() {
        recordsListVC.navigationItem.leftBarButtonItem?.click()
        XCTAssertEqual(router.receivedEvents, [.displayTrash])
    }

    func testThat__its_right_navigation_bar_button_adds_a_record() {
        recordsListVC.navigationItem.rightBarButtonItem?.click()
        XCTAssertEqual(router.receivedEvents, [.addRecord])
    }
}
