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

    func testThat__when_received_edit_record_notification__it_shows_details_for_this_record() {
        var receivedRecordIds: [RecordIdentifier] = []
        var receivedSender: UIViewController?

        router._displayDetails = {
            receivedRecordIds = $0
            receivedSender = $1
        }

        // the record does not even need to be displayed in this list view controller
        let editedRecord = trashStorage.all.first!

        NotificationCenter.default.post(name: .didEditRecord, object: editedRecord)

        XCTAssertEqual(router.receivedEvents, [.displayDetails])
        XCTAssertEqual(receivedRecordIds, [editedRecord.identifier])
        XCTAssertEqual(receivedSender, recordsListVC)
    }

    func testThat__when_received_edit_record_notification_for_displayed_record__it_highlights_the_corresponding_cell() {
        reloadViewControllerData()

        XCTAssertTrue((recordsListVC.tableView.indexPathsForSelectedRows ?? []).isEmpty, "no cells initially selected")
        NotificationCenter.default.post(name: .didEditRecord, object: Records.john)

        expectation(
            for: NSPredicate(block: { vc, _ in
                (vc as? RecordsListViewController)?
                    .tableView.indexPathsForSelectedRows == [IndexPath(row: 0, section: 0)]
            }),
            evaluatedWith: recordsListVC,
            handler: nil
        )

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testThat__when_received_edit_record_notification_for_displayed_record__it_highlights_cell_on_state_restore() {
        // BEGIN: previous test case stuff (it is a precondition for the current test case)
        reloadViewControllerData(for: recordsListVC)

        XCTAssertTrue((recordsListVC.tableView.indexPathsForSelectedRows ?? []).isEmpty, "no cells initially selected")
        NotificationCenter.default.post(name: .didEditRecord, object: Records.john)

        expectation(
            for: NSPredicate(block: { vc, _ in
                (vc as? RecordsListViewController)?
                    .tableView.indexPathsForSelectedRows == [IndexPath(row: 0, section: 0)]
            }),
            evaluatedWith: recordsListVC,
            handler: nil
        )

        waitForExpectations(timeout: 1.0, handler: nil)
        // END: previous test case stuff

        let coder = StubCoder()
        recordsListVC.encodeRestorableState(with: coder)

        let otherRecordsListVC = viewControllersFactory.makeViewController(for: screenDescriptor)
            as! RecordsListViewController

        reloadViewControllerData(for: otherRecordsListVC)

        XCTAssertTrue(
            (otherRecordsListVC.tableView.indexPathsForSelectedRows ?? []).isEmpty,
            "no cells initially selected in freshly created records list VC"
        )

        otherRecordsListVC.decodeRestorableState(with: coder)
        reloadViewControllerData(for: otherRecordsListVC)

        XCTAssertEqual(
            otherRecordsListVC.tableView.indexPathsForSelectedRows,
            [IndexPath(row: 0, section: 0)],
            "it selects the first row after restoring state saved by another instance of RecordsListViewController"
        )
    }

    func testThat__when_edited_an_older_record__it_highlights_the_right_cell() {
        recordsListVC = viewControllersFactory.makeViewController(for:
            .detailsForMultipleRecords(with: [
                Records.leslieOlder.identifier,
                Records.leslieRecent.identifier
            ])
        ) as? RecordsListViewController

        reloadViewControllerData()

        XCTAssertTrue((recordsListVC.tableView.indexPathsForSelectedRows ?? []).isEmpty, "no cells initially selected")
        NotificationCenter.default.post(name: .didEditRecord, object: Records.leslieOlder)

        expectation(
            for: NSPredicate(block: { vc, _ in
                (vc as? RecordsListViewController)?
                    // note the index path here: records are sorted from most recent to most old
                    // and here we expect the older one to be selected
                    .tableView.indexPathsForSelectedRows == [IndexPath(row: 1, section: 0)]
            }),
            evaluatedWith: recordsListVC,
            handler: nil
        )

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testThat__it_does_not_highlight_any_cells_for_irrelevant_records() {
        reloadViewControllerData(for: recordsListVC)

        XCTAssertTrue((recordsListVC.tableView.indexPathsForSelectedRows ?? []).isEmpty, "no cells initially selected")
        NotificationCenter.default.post(name: .didEditRecord, object: trashStorage.all.first!)

        let noCellsAreHighlightedExpectation = expectation(
            for: NSPredicate(block: { vc, _ in
                ((vc as? RecordsListViewController)?
                    .tableView.indexPathsForSelectedRows ?? []).isEmpty == false
            }),
            evaluatedWith: recordsListVC,
            handler: nil
        )

        noCellsAreHighlightedExpectation.isInverted = true

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
