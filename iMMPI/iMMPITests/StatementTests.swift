import XCTest

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
}
