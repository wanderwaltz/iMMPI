import XCTest
@testable import Serialization

final class JSONAgeGroupSerializationTests: XCTestCase {
    var serialization: JSONAgeGroupSerialization!

    override func setUp() {
        super.setUp()
        serialization = JSONAgeGroupSerialization()
    }


    func test__encode() {
        XCTAssertEqual(serialization.encode(.adult), JSONAgeGroupSerialization.Value.adult)
        XCTAssertEqual(serialization.encode(.teen), JSONAgeGroupSerialization.Value.teen)
        XCTAssertEqual(serialization.encode(.unknown), JSONAgeGroupSerialization.Value.unknown)
    }


    func test__decode__valid() {
        XCTAssertEqual(serialization.decode(JSONAgeGroupSerialization.Value.adult), .adult)
        XCTAssertEqual(serialization.decode(JSONAgeGroupSerialization.Value.teen), .teen)
        XCTAssertEqual(serialization.decode(JSONAgeGroupSerialization.Value.unknown), .unknown)
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
