import XCTest
@testable import iMMPI

final class AgeGroupTests: XCTestCase {
    func testToggled() {
        XCTAssertEqual(AgeGroup.adult.toggled(), AgeGroup.teen)
        XCTAssertEqual(AgeGroup.teen.toggled(), AgeGroup.adult)
        XCTAssertEqual(AgeGroup.unknown.toggled(), AgeGroup.adult)
    }


    func testDescription() {
        XCTAssertEqual(AgeGroup.adult.description, Strings.Value.ageGroupAdult)
        XCTAssertEqual(AgeGroup.teen.description, Strings.Value.ageGroupTeen)
        XCTAssertEqual(AgeGroup.unknown.description, Strings.Value.unknown)
    }
}
