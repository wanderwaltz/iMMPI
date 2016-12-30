import XCTest
@testable import iMMPI

final class StatementTests: XCTestCase {
    func testThat__default_statement_has_nonnull_text() {
        let text: String? = Statement().text
        XCTAssertNotNil(text)
    }

    func testThat__default_statement_has_empty_text() {
        XCTAssertTrue(Statement().text.isEmpty)
    }

    func testThat__default_statement_has_zero_id() {
        XCTAssertEqual(Statement().statementID, 0)
    }

    func testThat__statements_with_equal_id_are_equal_regardless_of_text() {
        let statement1 = Statement(identifier: 123, text: "some text")
        let statement2 = Statement(identifier: 123, text: "some text")
        let statement3 = Statement(identifier: 123, text: "different text")

        XCTAssertEqual(statement1, statement2)
        XCTAssertEqual(statement1, statement3)

        XCTAssertTrue(statement1.isEqual(statement2))
        XCTAssertTrue(statement1.isEqual(statement3))
        XCTAssertTrue(statement2.isEqual(statement3))

        XCTAssertTrue(statement2.isEqual(statement1))
        XCTAssertTrue(statement3.isEqual(statement1))
        XCTAssertTrue(statement3.isEqual(statement2))
    }

    func testThat__statements_with_different_ids_are_not_equal_regardless_of_text() {
        let statement1 = Statement(identifier: 123, text: "some text")
        let statement2 = Statement(identifier: 456, text: "some text")
        let statement3 = Statement(identifier: 789, text: "different text")

        XCTAssertNotEqual(statement1, statement2)
        XCTAssertNotEqual(statement1, statement3)

        XCTAssertFalse(statement1.isEqual(statement2))
        XCTAssertFalse(statement1.isEqual(statement3))
        XCTAssertFalse(statement2.isEqual(statement3))

        XCTAssertFalse(statement2.isEqual(statement1))
        XCTAssertFalse(statement3.isEqual(statement1))
        XCTAssertFalse(statement3.isEqual(statement2))
    }

    func testThat__statements_with_equal_id_have_equal_hashes() {
        let statement1 = Statement(identifier: 123, text: "some text")
        let statement2 = Statement(identifier: 123, text: "some text")
        let statement3 = Statement(identifier: 123, text: "different text")

        XCTAssertEqual(statement1.hash, statement2.hash)
        XCTAssertEqual(statement1.hash, statement3.hash)

        XCTAssertEqual(statement1.hashValue, statement2.hashValue)
        XCTAssertEqual(statement1.hashValue, statement3.hashValue)
    }

    func testThat__statements_are_not_equal_to_other_things() {
        let statement = Statement(identifier: 123, text: "some text")

        XCTAssertFalse(statement.isEqual(123))
        XCTAssertFalse(statement.isEqual("some text"))
        XCTAssertFalse(statement.isEqual(NSObject()))
        XCTAssertFalse(statement.isEqual(false))
        XCTAssertFalse(statement.isEqual(nil))
    }
}
