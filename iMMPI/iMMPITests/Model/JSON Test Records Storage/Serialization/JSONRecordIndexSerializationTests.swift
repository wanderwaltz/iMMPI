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

        let proxy1 = JSONRecordProxy(indexItem: indexItem1, materialize: JSONIndexItem.materializeRecord)
        let proxy2 = JSONRecordProxy(indexItem: indexItem2, materialize: JSONIndexItem.materializeRecord)

        let encoded = serialization.encode([proxy1, proxy2])
        let decodedProxies = serialization.decode(encoded)

        XCTAssertEqual(proxy1.date, decodedProxies[0].date)
        XCTAssertEqual(proxy1.personName, decodedProxies[0].personName)
        XCTAssertEqual(proxy1.fileName, decodedProxies[0].fileName)
        XCTAssertEqual(proxy1.directory, decodedProxies[0].directory)

        XCTAssertEqual(proxy2.date, decodedProxies[1].date)
        XCTAssertEqual(proxy2.personName, decodedProxies[1].personName)
        XCTAssertEqual(proxy2.fileName, decodedProxies[1].fileName)
        XCTAssertEqual(proxy2.directory, decodedProxies[1].directory)
    }
}
