import XCTest
@testable import iMMPI

final class JSONRecordProxySerializationTests: XCTestCase {
    var serialization: JSONRecordProxySerialization!

    override func setUp() {
        super.setUp()
        serialization = JSONRecordProxySerialization()
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
            directory: .init(name: "directory")
        )

        let proxy = JSONRecordProxy(indexItem: indexItem, materialize: JSONIndexItem.materializeRecord)

        let encoded = serialization.encode(proxy)
        let decodedProxy = serialization.decode(encoded)!

        XCTAssertEqual(proxy.date, decodedProxy.date)
        XCTAssertEqual(proxy.personName, decodedProxy.personName)
        XCTAssertEqual(proxy.fileName, decodedProxy.fileName)
        XCTAssertEqual(proxy.directory, decodedProxy.directory)
    }
}
