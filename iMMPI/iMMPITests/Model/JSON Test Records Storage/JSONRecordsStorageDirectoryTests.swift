import XCTest
@testable import iMMPI

final class JSONRecordsStorageDirectoryTests: XCTestCase {
    func testThat__default_storage_directories_are_distinct() {
        XCTAssertNotEqual(JSONRecordsStorageDirectory.default, JSONRecordsStorageDirectory.trash)
    }
}
