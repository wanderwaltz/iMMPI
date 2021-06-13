import XCTest
import DataModel

final class StatementTests: XCTestCase {
    func testThat__statements_with_equal_id_are_equal_regardless_of_text() {
        let statement1 = Statement(identifier: 123, text: "some text")
        let statement2 = Statement(identifier: 123, text: "some text")
        let statement3 = Statement(identifier: 123, text: "different text")

        XCTAssertEqual(statement1, statement2)
        XCTAssertEqual(statement1, statement3)
    }

    func testThat__statements_with_different_ids_are_not_equal_regardless_of_text() {
        let statement1 = Statement(identifier: 123, text: "some text")
        let statement2 = Statement(identifier: 456, text: "some text")
        let statement3 = Statement(identifier: 789, text: "different text")

        XCTAssertNotEqual(statement1, statement2)
        XCTAssertNotEqual(statement1, statement3)
    }

    func testThat__statements_with_equal_id_have_equal_hashes() {
        let statement1 = Statement(identifier: 123, text: "some text")
        let statement2 = Statement(identifier: 123, text: "some text")
        let statement3 = Statement(identifier: 123, text: "different text")

        XCTAssertEqual(statement1.hashValue, statement2.hashValue)
        XCTAssertEqual(statement1.hashValue, statement3.hashValue)
    }
}
