import XCTest
@testable import Formatters

final class NilToEmptyStringTests: XCTestCase {
    func testThat__nilToEmptyString__returns_object_description_for_nonnil_values() {
        XCTAssertEqual(nilToEmptyString("qwerty"), "qwerty")
        XCTAssertEqual(nilToEmptyString(123), "123")
        XCTAssertEqual(nilToEmptyString(true), "true")
        XCTAssertEqual(nilToEmptyString(false), "false")
    }

    func testThat__nilToEmptyString__returns_empty_string_for_nil_values() {
        XCTAssertEqual(nilToEmptyString(nil), "")
    }
}
