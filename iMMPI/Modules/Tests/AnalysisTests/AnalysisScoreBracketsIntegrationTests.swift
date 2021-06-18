import XCTest
import AnalysisTestSamples
@testable import Analysis

final class AnalysisScoreBracketsIntegrationTests: XCTestCase {
    var score: AnalysisScore!

    override func setUp() {
        super.setUp()
        score = .brackets(
            (26, 33, 49, 55),

            basedOn:
            .rawPercentage(
                positive: [95, 143, 144, 204, 223, 232, 264, 287, 369, 373, 400, 415, 434, 461, 498, 537, 556],
                negative: [21, 30, 45, 102, 105, 195, 208, 217, 225, 231, 255, 322, 370, 374, 465, 499]
            )
        )
    }


    func testThat__it_returns_expected_values() {
        XCTAssertEqual(score.value(for: TestSamples.record(at: 0)).score, 1.2)  // 0.0..<1.5
        XCTAssertEqual(score.value(for: TestSamples.record(at: 4)).score, 2.1)  // 1.5..<2.5
        XCTAssertEqual(score.value(for: TestSamples.record(at: 2)).score, 2.9)  // 2.5..<3.5
        XCTAssertEqual(score.value(for: TestSamples.record(at: 37)).score, 3.8) // 3.5..<4.5
        XCTAssertEqual(score.value(for: TestSamples.record(at: 3)).score, 4.6)  // 4.5..<5.0
    }
}
