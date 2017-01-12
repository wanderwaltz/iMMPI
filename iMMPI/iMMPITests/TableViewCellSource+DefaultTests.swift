import XCTest
@testable import iMMPI

final class TableViewCellSourceDefaultTests: XCTestCase {
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = UITableView(frame: .zero)
    }


    func testThat__returned_cell_has_the_given_reuse_identifier() {
        let source = TableViewCellSource<Int>(style: .default, identifier: "qwerty", update: { _ in })
        XCTAssertEqual(source.dequeue(from: tableView, with: nil).reuseIdentifier, "qwerty")
    }


    func testThat__it_calls_update_closure_on_a_cell() {
        let source = TableViewCellSource<Int>(style: .default, identifier: "qwerty", update: { cell, data in
            cell.textLabel?.text = data.map { String(describing: $0) } ?? "(null)"
        })

        XCTAssertEqual(source.dequeue(from: tableView, with: nil).textLabel?.text, "(null)")
        XCTAssertEqual(source.dequeue(from: tableView, with: 123).textLabel?.text, "123")
        XCTAssertEqual(source.dequeue(from: tableView, with: -5).textLabel?.text, "-5")
    }


    func testThat__cells_are_actually_reused() {
        let source = TableViewCellSource<Int>(style: .default, identifier: "qwerty", update: { _ in })
        let testTableView = TestTableView()
        XCTAssertTrue(source.dequeue(from: testTableView, with: 1234) === testTableView.reusedCell)
    }


    final class TestTableView: UITableView {
        let reusedCell = UITableViewCell()

        override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
            return reusedCell
        }
    }
}
