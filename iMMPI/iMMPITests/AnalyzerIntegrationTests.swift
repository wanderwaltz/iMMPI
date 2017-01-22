import XCTest
@testable import iMMPI

final class AnalyzerIntegrationTests: XCTestCase {
    let numberOfTestCases = 454
    let serialization = JSONTestRecordSerialization()

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
        if numberOfTestCases > 400 {
            validateTestCases(in: 400..<numberOfTestCases)
        }
    }


    func validateTestCases(in range: CountableRange<Int>) {
        for i in (0..<numberOfTestCases).clamped(to: range) {
            let testRecord = TestSamples.record(at: i)
            let scores = TestSamples.rawAnalysis(at: i)

            XCTAssertNotEqual(testRecord.person.gender, .unknown)
            XCTAssertNotEqual(testRecord.person.ageGroup, .unknown)

            for groupIndex in 0..<analyser.groupsCount {
                let score = analyser.group(at: groupIndex)!.computeScore(forRecord: testRecord, analyser: analyser)
                let expectedScore = scores[Int(groupIndex)]

                XCTAssertMatchingScores(score, expectedScore, "Score failed for: \(testRecord.personName), groupIndex: \(groupIndex), expected: \(expectedScore), got: \(score)")
            }
        }
    }
}


func XCTAssertMatchingScores(_ actual: Double,
                             _ expected: Any,
                             _ message: @autoclosure () -> String,
                             file: StaticString = #file, line: UInt = #line) {
    if expected is NSNull {
        XCTAssertTrue(actual.isNaN, message, file: file, line: line)
    }
    else {
        XCTAssertEqual(actual, expected as! Double, message, file: file, line: line)
    }
}
