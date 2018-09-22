import XCTest
@testable import iMMPI

final class ComputedScoreFormatterDefaultsTests: XCTestCase {
    func testThat__default_ComputedScoreFormatter__returns_computed_score_description() {
        let formatter = ComputedScoreFormatter.default

        let received_result1 = formatter.format(
            ComputedScore(
                rawValue: 123.456,
                description: "expected_result",
                isWithinNorm: true
            )
        )

        let received_result2 = formatter.format(
            ComputedScore(
                rawValue: 789.123,
                description: "expected_result",
                isWithinNorm: false
            )
        )

        XCTAssertEqual(received_result1, "expected_result")
        XCTAssertEqual(received_result2, "expected_result")
    }

    func testThat__filtered_ComputedScoreFormatter__returns_placeholder_for_scores_within_norm() {
        let formatter = ComputedScoreFormatter.filtered

        let received_result1 = formatter.format(
            ComputedScore(
                rawValue: 123.456,
                description: "expected_result",
                isWithinNorm: true
            )
        )

        let received_result2 = formatter.format(
            ComputedScore(
                rawValue: 789.123,
                description: "expected_result",
                isWithinNorm: false
            )
        )

        XCTAssertEqual(received_result1, Strings.Analysis.normalScorePlaceholder)
        XCTAssertEqual(received_result2, "expected_result")
    }
}
