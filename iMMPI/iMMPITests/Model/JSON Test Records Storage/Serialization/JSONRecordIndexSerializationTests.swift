import XCTest
@testable import iMMPI

final class JSONRecordIndexSerializationTests: XCTestCase {
    var serialization: JSONRecordIndexSerialization!

    override func setUp() {
        super.setUp()
        serialization = JSONRecordIndexSerialization()
    }

    func testThat__it_is_bidirectional() {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()

        dateComponents.year = 2000
        dateComponents.month = 11
        dateComponents.day = 25

        let date1 = calendar.date(from: dateComponents)!

        let indexItem1 = JSONIndexItem(
            personName: "John Appleseed",
            date: date1,
            fileName: "filename1",
            directory: .init(name: "directory1")
        )

        dateComponents.year = 2012
        dateComponents.month = 1
        dateComponents.day = 5

        let date2 = calendar.date(from: dateComponents)!

        let indexItem2 = JSONIndexItem(
            personName: "Daniel Melon",
            date: date2,
            fileName: "filename2",
            directory: .init(name: "directory2")
        )

        let encoded = serialization.encode([indexItem1, indexItem2])
        let decodedItems = serialization.decode(encoded)

        XCTAssertEqual(indexItem1.date, decodedItems[0].date)
        XCTAssertEqual(indexItem1.personName, decodedItems[0].personName)
        XCTAssertEqual(indexItem1.fileName, decodedItems[0].fileName)
        XCTAssertEqual(indexItem1.directory, decodedItems[0].directory)

        XCTAssertEqual(indexItem2.date, decodedItems[1].date)
        XCTAssertEqual(indexItem2.personName, decodedItems[1].personName)
        XCTAssertEqual(indexItem2.fileName, decodedItems[1].fileName)
        XCTAssertEqual(indexItem2.directory, decodedItems[1].directory)
    }
}
