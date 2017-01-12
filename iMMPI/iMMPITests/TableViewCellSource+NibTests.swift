import XCTest
import UIKit
@testable import iMMPI

final class TableViewCellSourceNibTests: XCTestCase {
    var tableView: TestTableView!
    let nib = UINib(nibName: "StatementTableViewCell+Input", bundle: Bundle(for: StatementTableViewCell.self))

    override func setUp() {
        super.setUp()
        tableView = TestTableView(frame: .zero)
    }

    final class TestTableView: UITableView {
        var lastRegisteredNib: UINib?
        var lastRegisteredNibReuseIdentifier: String?

        override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
            lastRegisteredNib = nib
            lastRegisteredNibReuseIdentifier = identifier
            super.register(nib, forCellReuseIdentifier: identifier)
        }
    }


    func testThat__it_registers_nib_in_table_view() {
        let source = TableViewCellSource<Int>.nib(self.nib, identifier: "qwerty", update: { (cell: UITableViewCell, _) in })

        XCTAssertNil(tableView.lastRegisteredNib)
        XCTAssertNil(tableView.lastRegisteredNibReuseIdentifier)

        source.register(in: tableView)

        XCTAssertTrue(tableView.lastRegisteredNib === nib)
        XCTAssertEqual(tableView.lastRegisteredNibReuseIdentifier, "qwerty")
    }


    func testThat__it_uses_cell_class_name_as_reuse_identifier_by_default() {
        let source = TableViewCellSource<Int>.nib(self.nib, update: { (cell: StatementTableViewCell, _) in })

        XCTAssertNil(tableView.lastRegisteredNibReuseIdentifier)

        source.register(in: tableView)

        XCTAssertEqual(tableView.lastRegisteredNibReuseIdentifier, "StatementTableViewCell")
    }


    func testThat__it_dequeues_a_cell_of_the_class_provided_in_update_closure() {
        let source = TableViewCellSource<Int>
            .nib(self.nib, update: { (cell: StatementTableViewCell, _) in })

        source.register(in: tableView)
        XCTAssertTrue(source.dequeue(from: tableView, with: nil) is StatementTableViewCell)
    }


    func testThat__it_uses_cell_class_for_loading_nib_by_default() {
        let source = TableViewCellSource<Int>.nib(update: { (cell: AnalyserTableViewCell, _) in })

        source.register(in: tableView)
        XCTAssertTrue(source.dequeue(from: tableView, with: nil) is AnalyserTableViewCell)
    }


    func testThat__it_calls_update_closure_on_a_cell() {
        let source = TableViewCellSource<Int>
            .nib(self.nib, update: { (cell: StatementTableViewCell, data: Int?) in
                cell.identifierLabel?.text = data.map { String(describing: $0) } ?? "(null)"
            })

        source.register(in: tableView)

        XCTAssertEqual((source.dequeue(from: tableView, with: nil) as! StatementTableViewCell)
            .identifierLabel?.text, "(null)")

        XCTAssertEqual((source.dequeue(from: tableView, with: 123) as! StatementTableViewCell)
            .identifierLabel?.text, "123")

        XCTAssertEqual((source.dequeue(from: tableView, with: -5) as! StatementTableViewCell)
            .identifierLabel?.text, "-5")
    }
}
