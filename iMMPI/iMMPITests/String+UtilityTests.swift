import XCTest
@testable import iMMPI

final class StringUtilityTests: XCTestCase {
    func testThat__empty_string__transliterated__is_empty() {
        XCTAssertEqual("".transliterated, "")
    }


    func testThat__string_is_transliterated_properly() {
        XCTAssertEqual("Иван Иванов".transliterated, "Ivan Ivanov")
        XCTAssertEqual("Лев Толстой".transliterated, "Lev Tolstoj")
        XCTAssertEqual("Яков Юрий".transliterated, "Akov Urij")
    }
}
