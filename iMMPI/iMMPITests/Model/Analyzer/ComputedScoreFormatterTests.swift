import XCTest
@testable import iMMPI

final class ComputedScoreFormatterTests: XCTestCase {
    func testThat__it_receives_the_provided_score_as_a_parameter_to_its_block() {
        var receivedScore: ComputedScore?

        let formatter = ComputedScoreFormatter({
            receivedScore = $0
            return $0.description
        })

        let expectedScore = ComputedScore(
            rawValue: 123.456,
            description: "score_description",
            isWithinNorm: true
        )

        _ = formatter.format(expectedScore)

        XCTAssertEqual(receivedScore?.rawValue, expectedScore.rawValue)
        XCTAssertEqual(receivedScore?.description, expectedScore.description)
        XCTAssertEqual(receivedScore?.isWithinNorm, expectedScore.isWithinNorm)
    }

    func testThat__it_returns_what_the_block_returns() {
        let formatter = ComputedScoreFormatter({ _ in
            return "expected_result"
        })

        let received_result = formatter.format(
            ComputedScore(
                rawValue: 123.456,
                description: "score_description",
                isWithinNorm: true
            )
        )

        XCTAssertEqual(received_result, "expected_result")
    }
}
