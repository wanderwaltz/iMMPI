import UIKit
import DataModel
import Serialization

public enum TestSamples {
    private static let bundle = Bundle.module
    private static let recordSerialization = JSONRecordSerialization()

    public static func record(at index: Int) -> Record {
        let answersFileName = String(format: "Test Subject 00%.3d", index)
        let answersFileUrl = bundle.url(forResource: answersFileName, withExtension: "json")!
        let answersData = try! Data(contentsOf: answersFileUrl)
        return recordSerialization.decode(answersData)!
    }

    public static func rawAnalysis(at index: Int) -> [Any] {
        let answersFileName = String(format: "Test Subject 00%.3d", index)
        let scoresFileName = "\(answersFileName) - scores"
        let scoresFileUrl = bundle.url(forResource: scoresFileName, withExtension: "json")!
        let scoresData = try! Data(contentsOf: scoresFileUrl)
        return try! JSONSerialization.jsonObject(with: scoresData, options: []) as! [Any]
    }
}
