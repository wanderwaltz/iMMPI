import XCTest
@testable import iMMPI

final class SpaceSeparatedIntsSerializationTests: XCTestCase {
    var serialization: SpaceSeparatedIntsSerialization!

    override func setUp() {
        super.setUp()
        serialization = SpaceSeparatedIntsSerialization()
    }

    func testThat__it_returns_empty_array_for_invalid_data() {
        XCTAssertEqual(serialization.decode(nil), [])
        XCTAssertEqual(serialization.decode(123), [])
        XCTAssertEqual(serialization.decode(NSObject()), [])
        XCTAssertEqual(serialization.decode(Data()), [])
        XCTAssertEqual(serialization.decode(Date()), [])
        XCTAssertEqual(serialization.decode(true), [])
        XCTAssertEqual(serialization.decode(false), [])
        XCTAssertEqual(serialization.decode("qwerty"), [])
        XCTAssertEqual(serialization.decode(""), [])
    }


    func testThat__it_parses_space_separated_ints_as_expected() {
        XCTAssertEqual(serialization.decode("1 2 3"), [1, 2, 3])
        XCTAssertEqual(serialization.decode("568 -1 123 4 56"), [568, -1, 123, 4, 56])
    }


    func testThat__it_ignores_non_number_substrings() {
        XCTAssertEqual(serialization.decode("1 2 abc 3 def"), [1, 2, 3])
        XCTAssertEqual(serialization.decode("1 2 3qwerty 4.5 5"), [1, 2, 5])
    }
}
