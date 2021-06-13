import XCTest
import Formatters

final class AbbreviatedNameFormatterTests: XCTestCase {
    var formatter: AbbreviatedNameFormatter!

    override func setUp() {
        super.setUp()
        formatter = AbbreviatedNameFormatter()
    }

    func testThat__it_returns_nil__for_nil_input() {
        XCTAssertNil(formatter.string(for: nil))
    }

    func testThat__it_returns_nil__for_non_string_input() {
        XCTAssertNil(formatter.string(for: NSObject()))
        XCTAssertNil(formatter.string(for: 123))
        XCTAssertNil(formatter.string(for: false))
        XCTAssertNil(formatter.string(for: true))
        XCTAssertNil(formatter.string(for: [String]()))
    }

    func testThat__it_abbreviates_all_components_besides_the_first() {
        XCTAssertEqual(formatter.string(for: "Достоевский Федор Михайлович"), "Достоевский Ф. М.")
        XCTAssertEqual(formatter.string(for: "Иванов"), "Иванов")
        XCTAssertEqual(formatter.string(for: "Толстой Лев"), "Толстой Л.")
        XCTAssertEqual(formatter.string(for: "Первый Второй Третий Четвертый"), "Первый В. Т. Ч.")
        XCTAssertEqual(formatter.string(for: ""), "")
    }
}
