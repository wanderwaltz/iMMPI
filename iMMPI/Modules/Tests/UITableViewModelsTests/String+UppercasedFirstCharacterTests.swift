import XCTest
@testable import UITableViewModels

final class StringUppercasedFirstCharacterTests: XCTestCase {
    func test_uppercasedFirstCharacter() {
        XCTAssertEqual("".uppercasedFirstCharacter, "")
        XCTAssertEqual("apple".uppercasedFirstCharacter, "A")
        XCTAssertEqual("Apple".uppercasedFirstCharacter, "A")
        XCTAssertEqual("two words".uppercasedFirstCharacter, "T")
        XCTAssertEqual("123".uppercasedFirstCharacter, "1")
        XCTAssertEqual("qwerty asdfg eiy".uppercasedFirstCharacter, "Q")
    }
}
