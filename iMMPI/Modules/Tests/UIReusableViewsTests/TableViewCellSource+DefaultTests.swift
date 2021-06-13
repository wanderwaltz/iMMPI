import XCTest
import Utils
@testable import UIReusableViews

final class TableViewCellSourceDefaultTests: XCTestCase {
    var tableView: UITableView!
    var dataSource: StubTableViewDataSource!

    override func setUp() {
        super.setUp()
        dataSource = StubTableViewDataSource()
        dataSource._numberOfSections = Constant.value(1)
        dataSource._numberOfRows = Constant.value(1)

        tableView = UITableView(frame: .zero)
        tableView.dataSource = dataSource
    }


    func testThat__returned_cell_has_the_given_reuse_identifier() {
        let source = TableViewCellSource<Int>(style: .default, identifier: "qwerty", update: { _, _ in })
        source.register(in: tableView)
        XCTAssertEqual(source.dequeue(from: tableView, for: IndexPath(row: 0, section: 0), with: nil).reuseIdentifier, "qwerty")
    }


    func testThat__it_calls_update_closure_on_a_cell() {
        let source = TableViewCellSource<Int>(style: .default, identifier: "qwerty", update: { cell, data in
            cell.textLabel?.text = data.map { String(describing: $0) } ?? "(null)"
        })

        source.register(in: tableView)

        XCTAssertEqual(source.dequeue(from: tableView, for: IndexPath(row: 0, section: 0), with: nil).textLabel?.text, "(null)")
        XCTAssertEqual(source.dequeue(from: tableView, for: IndexPath(row: 0, section: 0), with: 123).textLabel?.text, "123")
        XCTAssertEqual(source.dequeue(from: tableView, for: IndexPath(row: 0, section: 0), with: -5).textLabel?.text, "-5")
    }


    func testThat__cells_are_actually_reused() {
        let source = TableViewCellSource<Int>(style: .default, identifier: "qwerty", update: { _, _ in })
        let testTableView = TestTableView()
        source.register(in: testTableView)
        XCTAssertTrue(source.dequeue(from: testTableView, for: IndexPath(row: 0, section: 0), with: 1234) === testTableView.reusedCell)
    }


    final class TestTableView: UITableView {
        let reusedCell = UITableViewCell()

        override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell {
            return reusedCell
        }
    }
}
