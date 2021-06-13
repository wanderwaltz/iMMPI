import XCTest
import DataModel
import Localization

final class GenderTests: XCTestCase {
    func testToggled() {
        XCTAssertEqual(Gender.male.toggled(), Gender.female)
        XCTAssertEqual(Gender.female.toggled(), Gender.male)
        XCTAssertEqual(Gender.unknown.toggled(), Gender.male)
    }


    func testDescription() {
        XCTAssertEqual(Gender.male.description, Strings.Value.genderMale)
        XCTAssertEqual(Gender.female.description, Strings.Value.genderFemale)
        XCTAssertEqual(Gender.unknown.description, Strings.Value.unknown)
    }
}
