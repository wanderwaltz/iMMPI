import XCTest
@testable import iMMPI

final class JSONTestRecordProxySerializationTests: XCTestCase {
    var serialization: JSONTestRecordProxySerialization!

    override func setUp() {
        super.setUp()
        serialization = JSONTestRecordProxySerialization()
    }

    func testThat__it_is_bidirectional() {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()

        dateComponents.year = 2000
        dateComponents.month = 11
        dateComponents.day = 25

        let date = calendar.date(from: dateComponents)!

        let proxy = JSONTestRecordProxy(fileName: "filename", directory: "directory")
        proxy.personName = "John Appleseed"
        proxy.date = date

        let encoded = serialization.encode(proxy)
        let decodedProxy = serialization.decode(encoded)!

        XCTAssertEqual(proxy.date, decodedProxy.date)
        XCTAssertEqual(proxy.personName, decodedProxy.personName)
        XCTAssertEqual(proxy.fileName, decodedProxy.fileName)
        XCTAssertEqual(proxy.directory, decodedProxy.directory)
    }
}
