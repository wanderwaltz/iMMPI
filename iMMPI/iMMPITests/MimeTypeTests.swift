import XCTest
@testable import iMMPI

final class MimeTypeTests: XCTestCase {
    func testHashable() {
        checkHashableImplementation(with: StringGenerator<MimeType>().makeIterator())
    }


    func testThat__description_matches_rawValue() {
        checkDescriptionMatchesRawValue(with: StringGenerator<MimeType>().makeIterator())
    }


    func testThat__default_mime_types__are_distinct() {
        XCTAssertNotEqual(MimeType.json, MimeType.html)
    }
}
