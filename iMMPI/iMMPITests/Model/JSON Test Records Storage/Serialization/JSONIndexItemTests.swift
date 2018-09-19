import XCTest
@testable import iMMPI

final class JSONIndexItemTests: XCTestCase {
    func testThat__initializing_with_a_record__inherits_records_properties() {
        let record = Record(
            person: Person(name: "John Appleseed"),
            date: Date(timeIntervalSince1970: 100)
        )

        let indexItem = JSONIndexItem(
            record: record,
            fileName: "fileName",
            directory: .init(name: "directory")
        )

        XCTAssertEqual(indexItem.personName, record.indexItem.personName)
        XCTAssertEqual(indexItem.date, record.date)
    }
}
