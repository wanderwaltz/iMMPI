import XCTest
@testable import iMMPI

final class JSONGenderSerializationTests: XCTestCase {
    var serialization: JSONGenderSerialization!

    override func setUp() {
        super.setUp()
        serialization = JSONGenderSerialization()
    }

    
    func test__encode() {
        XCTAssertEqual(serialization.encode(.male), JSONGenderSerialization.Value.male)
        XCTAssertEqual(serialization.encode(.female), JSONGenderSerialization.Value.female)
        XCTAssertEqual(serialization.encode(.unknown), JSONGenderSerialization.Value.unknown)
    }


    func test__decode__valid() {
        XCTAssertEqual(serialization.decode(JSONGenderSerialization.Value.male), .male)
        XCTAssertEqual(serialization.decode(JSONGenderSerialization.Value.female), .female)
        XCTAssertEqual(serialization.decode(JSONGenderSerialization.Value.unknown), .unknown)
    }


    func test__decode__invalid() {
        XCTAssertEqual(serialization.decode(nil), .unknown)
        XCTAssertEqual(serialization.decode("qwerty"), .unknown)
        XCTAssertEqual(serialization.decode(NSObject()), .unknown)
        XCTAssertEqual(serialization.decode(true), .unknown)
        XCTAssertEqual(serialization.decode(false), .unknown)
        XCTAssertEqual(serialization.decode(123), .unknown)
        XCTAssertEqual(serialization.decode(12.3), .unknown)
    }
}
