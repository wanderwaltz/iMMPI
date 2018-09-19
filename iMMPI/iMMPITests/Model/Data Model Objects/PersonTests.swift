import XCTest
@testable import iMMPI

final class PersonTests: XCTestCase {
    func testThat__default_person_has_nonnull_name() {
        let name: String? = Person().name
        XCTAssertNotNil(name)
    }

    func testThat__default_person_has_empty_name() {
        XCTAssertTrue(Person().name.isEmpty)
    }

    func testThat__default_person_is_male() {
        XCTAssertEqual(Person().gender, .male)
    }

    func testThat__default_person_is_adult() {
        XCTAssertEqual(Person().ageGroup, .adult)
    }
}
