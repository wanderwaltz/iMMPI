import XCTest
@testable import Serialization

final class JSONIndexItemSerializationTests: XCTestCase {
    var serialization: JSONIndexItemSerialization!

    override func setUp() {
        super.setUp()
        serialization = JSONIndexItemSerialization()
    }

    func testThat__it_is_bidirectional() {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()

        dateComponents.year = 2000
        dateComponents.month = 11
        dateComponents.day = 25

        let date = calendar.date(from: dateComponents)!

        let indexItem = JSONIndexItem(
            personName: "John Appleseed",
            date: date,
            fileName: "filename",
            directory: "directory"
        )

        let encoded = serialization.encode(indexItem)
        let decodedIndexItem = serialization.decode(encoded)!

        XCTAssertEqual(indexItem.date, decodedIndexItem.date)
        XCTAssertEqual(indexItem.personName, decodedIndexItem.personName)
        XCTAssertEqual(indexItem.fileName, decodedIndexItem.fileName)
        XCTAssertEqual(indexItem.directory, decodedIndexItem.directory)
    }
}
