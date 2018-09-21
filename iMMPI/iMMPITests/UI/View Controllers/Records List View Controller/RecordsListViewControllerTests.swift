import XCTest
@testable import iMMPI

final class RecordsListViewControllerTests: RecordsListViewControllerTestCase {
    func testThat__selecting_a_row_opens_details_for_the_corresponding_records_group() {
        var receivedRecordIds: [RecordIdentifier] = []
        var receivedSender: UIViewController?

        router._displayDetails = {
            receivedRecordIds = $0
            receivedSender = $1
        }

        reloadViewControllerData()

        // case 0: selecting a single record
        recordsListVC.tableView(recordsListVC.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(router.receivedEvents, [.displayDetails])
        XCTAssertEqual(receivedRecordIds, [Records.john.identifier])
        XCTAssertEqual(receivedSender, recordsListVC)


        // case 1: selecting a group of records
        router.receivedEvents = []

        recordsListVC.tableView(recordsListVC.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))

        XCTAssertEqual(router.receivedEvents, [.displayDetails])
        XCTAssertEqual(receivedRecordIds, [Records.leslieRecent.identifier, Records.leslieOlder.identifier])
        XCTAssertEqual(receivedSender, recordsListVC)
    }

    func testThat__selecting_row_accessory_opens_the_most_recent_record_for_editing() {
        var receivedRecordId: RecordIdentifier?
        var receivedSender: UIViewController?

        router._editRecord = {
            receivedRecordId = $0
            receivedSender = $1
        }

        reloadViewControllerData()

        // case 0: selecting a single record
        recordsListVC.tableView(recordsListVC.tableView, accessoryButtonTappedForRowWith: IndexPath(row: 0, section: 0))

        XCTAssertEqual(router.receivedEvents, [.editRecord])
        XCTAssertEqual(receivedRecordId, Records.john.identifier)
        XCTAssertEqual(receivedSender, recordsListVC)


        // case 1: selecting a group of records
        router.receivedEvents = []

        recordsListVC.tableView(recordsListVC.tableView, accessoryButtonTappedForRowWith: IndexPath(row: 0, section: 1))

        XCTAssertEqual(router.receivedEvents, [.editRecord])
        XCTAssertEqual(receivedRecordId, Records.leslieRecent.identifier)
        XCTAssertEqual(receivedSender, recordsListVC)
    }

    func testThat__deleting_a_single_record_removes_it_from_storage() {
        reloadViewControllerData()

        XCTAssertNotNil(storage.findRecord(with: Records.john.identifier))

        recordsListVC.tableView(recordsListVC.tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))

        XCTAssertNil(storage.findRecord(with: Records.john.identifier))
    }

    func testThat__deleting_a_group_of_records_removes_all_of_its_records_from_storage() {
        reloadViewControllerData()

        XCTAssertNotNil(storage.findRecord(with: Records.leslieOlder.identifier))
        XCTAssertNotNil(storage.findRecord(with: Records.leslieRecent.identifier))

        recordsListVC.tableView(recordsListVC.tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))

        XCTAssertNil(storage.findRecord(with: Records.leslieOlder.identifier))
        XCTAssertNil(storage.findRecord(with: Records.leslieRecent.identifier))
    }

    func testThat__it_stores_selected_record_identifier_when_encoding_state() {
        reloadViewControllerData(for: recordsListVC)
        recordsListVC.tableView(recordsListVC.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        let coder = StubCoder()
        recordsListVC.encodeRestorableState(with: coder)

        let otherListVC = viewControllersFactory.makeViewController(for: .allRecords) as! RecordsListViewController
        reloadViewControllerData(for: otherListVC)

        XCTAssertTrue(
            (otherListVC.tableView.indexPathsForSelectedRows ?? []).isEmpty,
            "no row is initially selected"
        )

        otherListVC.decodeRestorableState(with: coder)
        reloadViewControllerData(for: otherListVC)

        XCTAssertEqual(
            otherListVC.tableView.indexPathsForSelectedRows,
            [IndexPath(row: 0, section: 0)],
            "it selects the first row after restoring state saved by another instance of RecordsListViewController"
        )
    }
}
