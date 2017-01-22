import XCTest
@testable import iMMPI

final class GenderBasedValueTests: XCTestCase {
    func testThat__it_returns_different_values_for_different_genders() {
        let int = GenderBasedValue<Int>(male: 123, female: 456)

        XCTAssertEqual(int.value(for: .male), 123)
        XCTAssertEqual(int.value(for: .female), 456)
    }


    func testThat__it_falls_back_to_male_if_gender_is_unknown() {
        let int = GenderBasedValue<Int>(male: 123, female: 456)

        XCTAssertEqual(int.value(for: .unknown), 123)
    }


    func testThat__specific_returns_different_values_for_different_genders() {
        let int = GenderBasedValue<Int>.specific(male: 123, female: 456)

        XCTAssertEqual(int.value(for: .male), 123)
        XCTAssertEqual(int.value(for: .female), 456)
        XCTAssertEqual(int.value(for: .unknown), 123)
    }


    func testThat__common_returns_the_same_value_for_different_genders() {
        let int = GenderBasedValue<Int>.common(123)

        XCTAssertEqual(int.value(for: .male), 123)
        XCTAssertEqual(int.value(for: .female), 123)
        XCTAssertEqual(int.value(for: .unknown), 123)
    }
}
