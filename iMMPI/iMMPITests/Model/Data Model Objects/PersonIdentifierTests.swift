import XCTest
@testable import iMMPI

final class PersonIdentifierTests: XCTestCase {
    func testThat__person_identifier_can_be_initialized_with_raw_value() {
        XCTAssertNotNil(PersonIdentifier(rawValue: "John Appleseed"))
    }

    func testThat__person_identifier_initialized_with_name_is_the_same_as_with_raw_value() {
        let initializedWithName = PersonIdentifier(name: "John Appleseed")
        let initializedWithRawValue = PersonIdentifier(rawValue: "John Appleseed")
        XCTAssertEqual(initializedWithName, initializedWithRawValue)
    }

    func testThat__person_identifier_keeps_its_raw_value() {
        let personIdentifier = PersonIdentifier(rawValue: "John Appleseed")
        XCTAssertEqual(personIdentifier?.rawValue, "John Appleseed")
    }
}
