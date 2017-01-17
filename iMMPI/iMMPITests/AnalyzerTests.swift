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


    func testThat_samples_match_scores_group_0() {
        validateTestCases(in: 0..<50)
    }

    func testThat_samples_match_scores_group_1() {
        validateTestCases(in: 50..<100)
    }

    func testThat_samples_match_scores_group_2() {
        validateTestCases(in: 100..<150)
    }

    func testThat_samples_match_scores_group_3() {
        validateTestCases(in: 150..<200)
    }

    func testThat_samples_match_scores_group_4() {
        validateTestCases(in: 200..<250)
    }

    func testThat_samples_match_scores_group_5() {
        validateTestCases(in: 250..<300)
    }

    func testThat_samples_match_scores_group_6() {
        validateTestCases(in: 300..<350)
    }

    func testThat_samples_match_scores_group_7() {
        validateTestCases(in: 350..<400)
    }

    func testThat_samples_match_scores_group_8() {
        validateTestCases(in: 400..<numberOfTestCases)
    }


    func validateTestCases(in range: CountableRange<Int>) {
        let bundle = Bundle(for: type(of: self))

        for i in (0..<numberOfTestCases).clamped(to: range) {
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
