import XCTest
import EmailComposing

final class MimeTypeTests: XCTestCase {
    func testThat__default_mime_types__are_distinct() {
        XCTAssertNotEqual(MimeType.json, MimeType.html)
    }
}
