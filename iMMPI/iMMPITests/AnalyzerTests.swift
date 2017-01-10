import XCTest
@testable import iMMPI

final class AnalyzerIntegrationTests: XCTestCase {
    let numberOfTestCases = 454

    var analyser: Analyzer!

    override func setUp() {
        super.setUp()
        analyser = Analyzer()
        analyser.loadGroups()
    }


    func testThat_samples_match_scores() {
        let bundle = Bundle(for: type(of: self))

        for i in 0..<numberOfTestCases {
            let answersFileName = String(format: "Test Subject 00%.3d", i)
            let scoresFileName = "\(answersFileName) - scores"

            let answersFileUrl = bundle.url(forResource: answersFileName, withExtension: "json")!
            let scoresFileUrl = bundle.url(forResource: scoresFileName, withExtension: "json")!

            let answersData = try! Data(contentsOf: answersFileUrl)
            let scoresData = try! Data(contentsOf: scoresFileUrl)

            let testRecord = JSONTestRecordSerialization.testRecord(from: answersData)!
            let scores = try! JSONSerialization.jsonObject(with: scoresData, options: []) as! [Any]

            XCTAssertNotEqual(testRecord.person.gender, .unknown)
            XCTAssertNotEqual(testRecord.person.ageGroup, .unknown)

            for groupIndex in 0..<analyser.groupsCount {
                let score = analyser.group(at: groupIndex)!.computeScore(forRecord: testRecord, analyser: analyser)
                let expectedScore = scores[Int(groupIndex)]

                if expectedScore is NSNull {
                    XCTAssertTrue(score.isNaN, "Score failed for: \(testRecord.personName), groupIndex: \(groupIndex), expected: .nan, got: \(score)")
                }
                else {
                    XCTAssertEqual(score, expectedScore as! Double,
                                   "Score failed for: \(testRecord.personName), groupIndex: \(groupIndex), expected: \(expectedScore), got: \(score)")
                }
            }
        }
    }
}
