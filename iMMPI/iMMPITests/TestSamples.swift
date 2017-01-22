@testable import iMMPI

enum TestSamples {
    static let bundle = Bundle(for: AnalyzerIntegrationTests.self)
    static let recordSerialization = JSONTestRecordSerialization()

    static func record(at index: Int) -> TestRecord {
        let answersFileName = String(format: "Test Subject 00%.3d", index)
        let answersFileUrl = bundle.url(forResource: answersFileName, withExtension: "json")!
        let answersData = try! Data(contentsOf: answersFileUrl)
        return recordSerialization.decode(answersData)!
    }
}
