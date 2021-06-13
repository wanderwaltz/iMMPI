import XCTest
import DataModel
@testable import Analysis

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


    func testThat__specific__returns_different_values_for_different_genders() {
        let int = GenderBasedValue<Int>.specific(male: 123, female: 456)

        XCTAssertEqual(int.value(for: .male), 123)
        XCTAssertEqual(int.value(for: .female), 456)
        XCTAssertEqual(int.value(for: .unknown), 123)
    }


    func testThat__block_based_specific__returns_the_block_result() {
        var value = 0

        let int = GenderBasedValue<Int>.specific({ _ in
            defer {
                value += 1
            }

            return value
        })

        XCTAssertEqual(int.value(for: .male), 0)
        XCTAssertEqual(int.value(for: .male), 0)
        XCTAssertEqual(int.value(for: .male), 0)

        XCTAssertEqual(int.value(for: .female), 1)
        XCTAssertEqual(int.value(for: .female), 1)
        XCTAssertEqual(int.value(for: .female), 1)

        XCTAssertEqual(int.value(for: .unknown), 0)
        XCTAssertEqual(int.value(for: .unknown), 0)
        XCTAssertEqual(int.value(for: .unknown), 0)
    }


    func testThat__block_based_specific__immediately_receives_two_genders() {
        var receivedGenders: [Gender] = []

        _ = GenderBasedValue<Int>.specific({ gender in
            receivedGenders.append(gender)
            return 0
        })

        XCTAssertEqual(receivedGenders, [.male, .female])
    }


    func testThat__common__returns_the_same_value_for_different_genders() {
        let int = GenderBasedValue<Int>.common(123)

        XCTAssertEqual(int.value(for: .male), 123)
        XCTAssertEqual(int.value(for: .female), 123)
        XCTAssertEqual(int.value(for: .unknown), 123)
    }
}
