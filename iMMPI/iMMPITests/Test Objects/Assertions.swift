import XCTest
@testable import iMMPI

func XCTAssertMemberwiseEqual(_ p1: Person?, _ p2: Person?, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(p1?.name, p2?.name, file: file, line: line)
    XCTAssertEqual(p1?.gender, p2?.gender, file: file, line: line)
    XCTAssertEqual(p1?.ageGroup, p2?.ageGroup, file: file, line: line)
}

func XCTAssertNotMemberwiseEqual(_ p1: Person?, _ p2: Person?, file: StaticString = #file, line: UInt = #line) {
    if p1?.name != p2?.name
        || p1?.gender != p2?.gender
        || p1?.ageGroup != p2?.ageGroup {
        return
    }

    XCTFail("Expected \(String(describing: p1)) != \(String(describing: p2))", file: file, line: line)
}
