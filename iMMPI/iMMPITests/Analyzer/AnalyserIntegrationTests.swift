import XCTest
@testable import iMMPI

final class AnalyzerIntegrationTests: XCTestCase {
    let numberOfTestCases = 454
    let serialization = JSONRecordSerialization()

    var analyser: Analyser!

    override func setUp() {
        super.setUp()
        analyser = Analyser()
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
            let record = TestSamples.record(at: i)
            let scores = TestSamples.rawAnalysis(at: i)

            XCTAssertNotEqual(record.person.gender, .unknown)
            XCTAssertNotEqual(record.person.ageGroup, .unknown)

            let result = analyser.result(for: record)

            for i in 0..<analyser.scales.count {
                let actual = analyser.scales[i].score.value(for: record)
                let expected = scores[i]

                XCTAssertMatchingScores(actual, expected, "Score failed for: \(record.personName), scale: \(i), expected: \(expected), got: \(actual)")

                XCTAssertMatchingScores(result.scales[i].score.rawValue, expected, "Bound score failed for: \(record.personName), scale: \(i), expected: \(expected), got: \(actual)")
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
