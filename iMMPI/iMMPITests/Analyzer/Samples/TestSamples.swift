import UIKit
@testable import iMMPI

enum TestSamples {
    static let bundle = Bundle(for: AnalyzerIntegrationTests.self)
    static let recordSerialization = JSONRecordSerialization()

    static func record(at index: Int) -> Record {
        let answersFileName = String(format: "Test Subject 00%.3d", index)
        let answersFileUrl = bundle.url(forResource: answersFileName, withExtension: "json")!
        let answersData = try! Data(contentsOf: answersFileUrl)
        return recordSerialization.decode(answersData)!
    }


    static func rawAnalysis(at index: Int) -> [Any] {
        let answersFileName = String(format: "Test Subject 00%.3d", index)
        let scoresFileName = "\(answersFileName) - scores"
        let scoresFileUrl = bundle.url(forResource: scoresFileName, withExtension: "json")!
        let scoresData = try! Data(contentsOf: scoresFileUrl)
        return try! JSONSerialization.jsonObject(with: scoresData, options: []) as! [Any]
    }
}
