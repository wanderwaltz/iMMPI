import XCTest
@testable import iMMPI

final class JSONAnswerTypeSerializationTests: XCTestCase {
    var serialization: JSONAnswerTypeSerialization!

    override func setUp() {
        super.setUp()
        serialization = JSONAnswerTypeSerialization()
    }


    func test__encode() {
        XCTAssertEqual(serialization.encode(.positive), JSONAnswerTypeSerialization.Value.positive)
        XCTAssertEqual(serialization.encode(.negative), JSONAnswerTypeSerialization.Value.negative)
        XCTAssertEqual(serialization.encode(.unknown), JSONAnswerTypeSerialization.Value.unknown)
    }


    func test__decode__valid() {
        XCTAssertEqual(serialization.decode(JSONAnswerTypeSerialization.Value.positive), .positive)
        XCTAssertEqual(serialization.decode(JSONAnswerTypeSerialization.Value.negative), .negative)
        XCTAssertEqual(serialization.decode(JSONAnswerTypeSerialization.Value.unknown), .unknown)
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
