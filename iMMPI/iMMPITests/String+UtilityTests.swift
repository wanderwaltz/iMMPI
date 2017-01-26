import XCTest
@testable import iMMPI

final class StringUtilityTests: XCTestCase {
    func testThat__empty_string__transliterated__is_empty() {
        XCTAssertEqual("".mmpiTransliterated, "")
    }


    func testThat__string_is_transliterated_properly() {
        XCTAssertEqual("Иван Иванов".mmpiTransliterated, "Ivan Ivanov")
        XCTAssertEqual("Лев Толстой".mmpiTransliterated, "Lev Tolstoj")
        XCTAssertEqual("Яков Юрий".mmpiTransliterated, "Akov Urij")
    }
}
