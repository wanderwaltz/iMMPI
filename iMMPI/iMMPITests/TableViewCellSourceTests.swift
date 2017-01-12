import XCTest
@testable import iMMPI

final class TableViewCellSourceTests: XCTestCase {
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView(frame: .zero)
    }


    func testThat__it_calls_register_closure_when_registering() {
        var called = false

        let source = TableViewCellSource<Int>(register: { _ in called = true },
                                              dequeue: { _ in UITableViewCell() })

        source.register(in: tableView)
        XCTAssertTrue(called)
    }


    func testThat__it_passes_the_table_view_to_register_closure() {
        var receivedTableView: UITableView? = nil

        let source = TableViewCellSource<Int>(register: { receivedTableView = $0 },
                                              dequeue: { _ in UITableViewCell() })

        source.register(in: tableView)
        XCTAssertTrue(receivedTableView === tableView)
    }


    func testThat__it_calls_dequeue_closure_when_dequeueing() {
        var called = false

        let source = TableViewCellSource<Int>(
            register: { _ in },
            dequeue: { _ in
                called = true
                return UITableViewCell()
        })

        _ = source.dequeue(from: tableView, with: 123)
        XCTAssertTrue(called)
    }


    func testThat__it_passes_the_table_view_to_dequeue_closure() {
        var receivedTableView: UITableView? = nil

        let source = TableViewCellSource<Int>(
            register: { _ in },
            dequeue: { tableView, _ in
                receivedTableView = tableView
                return UITableViewCell()
        })

        _ = source.dequeue(from: tableView, with: 123)
        XCTAssertTrue(receivedTableView === tableView)
    }


    func testThat__it_passes_the_data_to_dequeue_closure() {
        var receivedData: NSObject? = nil
        let expectedData = NSObject()

        let source = TableViewCellSource<NSObject>(
            register: { _ in },
            dequeue: { _, data in
                receivedData = data
                return UITableViewCell()
        })

        _ = source.dequeue(from: tableView, with: expectedData)
        XCTAssertTrue(receivedData === expectedData)
    }


    func testThat__it_returns_the_dequeue_closure_result() {
        let expectedCells = [UITableViewCell(), UITableViewCell(), UITableViewCell()]
        var counter = 0

        let source = TableViewCellSource<Int>(
            register: { _ in },
            dequeue: { _ in
                defer {
                    counter += 1
                }

                return expectedCells[counter]
        })

        XCTAssertTrue(source.dequeue(from: tableView, with: 123) === expectedCells[0])
        XCTAssertTrue(source.dequeue(from: tableView, with: 45) === expectedCells[1])
        XCTAssertTrue(source.dequeue(from: tableView, with: 0) === expectedCells[2])
    }
}
