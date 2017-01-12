import XCTest
@testable import iMMPI

final class GenderTests: XCTestCase {
    func testToggled() {
        XCTAssertEqual(Gender.male.toggled(), Gender.female)
        XCTAssertEqual(Gender.female.toggled(), Gender.male)
        XCTAssertEqual(Gender.unknown.toggled(), Gender.male)
    }


    func testDescription() {
        XCTAssertEqual(Gender.male.description, Strings.genderMale)
        XCTAssertEqual(Gender.female.description, Strings.genderFemale)
        XCTAssertEqual(Gender.unknown.description, Strings.unknown)
    }
}
