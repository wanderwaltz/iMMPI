import XCTest
import AnalysisTestSamples
@testable import Analysis

final class AnalysisScoreMedianIntegrationTests: XCTestCase {
    var score: AnalysisScore!

    override func setUp() {
        super.setUp()
        score = .median(
            .specific(male: 18.13, female: 11.33),
            dispersion: .specific(male: 4.18, female: 4.38),
            basedOn: .raw(
                positive: [10, 23, 24, 29, 31, 32, 44, 47, 93, 97, 104, 125, 210, 212, 226,
                           241, 247, 303, 325, 352, 360, 375, 388, 422, 438, 453, 459, 475,
                           481, 518, 525, 535, 541, 543],
                negative: [68, 83, 88, 96, 257, 306]
            )
        )
    }


    func testThat__it_returns_expected_values() {
        XCTAssertEqual(score.value(for: TestSamples.record(at: 0)).score, 74.0)
        XCTAssertEqual(score.value(for: TestSamples.record(at: 1)).score, 54.0)
        XCTAssertEqual(score.value(for: TestSamples.record(at: 2)).score, 81.0)
        XCTAssertEqual(score.value(for: TestSamples.record(at: 3)).score, 38.0)
        XCTAssertEqual(score.value(for: TestSamples.record(at: 4)).score, 31.0)
        XCTAssertEqual(score.value(for: TestSamples.record(at: 5)).score, 28.0)
    }
}
