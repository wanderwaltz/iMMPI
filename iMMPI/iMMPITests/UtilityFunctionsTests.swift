import XCTest
@testable import iMMPI

final class UtilityFunctionsTests: XCTestCase {
    func test_uppercasedFirstCharacter() {
        XCTAssertEqual("".uppercasedFirstCharacter, "")
        XCTAssertEqual("apple".uppercasedFirstCharacter, "A")
        XCTAssertEqual("Apple".uppercasedFirstCharacter, "A")
        XCTAssertEqual("two words".uppercasedFirstCharacter, "T")
        XCTAssertEqual("123".uppercasedFirstCharacter, "1")
        XCTAssertEqual("qwerty asdfg eiy".uppercasedFirstCharacter, "Q")
    }
}
