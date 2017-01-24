import XCTest
@testable import iMMPI

final class AnalyserScoreFormattersTests: XCTestCase {
    var analyser: Analyser!

    override func setUp() {
        super.setUp()
        analyser = Analyser()
    }

    func testThat__all_zero_nested_scales_have_ignoring_formatter() {
        for scale in analyser.scales {
            if scale.identifier.nesting == 0 {
                XCTAssertEqualFormatters(scale.formatter, .ignore)
            }
        }
    }


    func testThat__nonzero_nested_scales_have_proper_formatters() {
        let record = TestSamples.record(at: 123)

        for scale in analyser.scales {
            guard scale.identifier.nesting > 0 else {
                continue
            }

            // an indirect way to detect which score computation method is used for the scale;
            // AnalysisScore is closure-based and thus is not comparable, so we use the domain
            // knowledge that bracketed scores are in 0...5 range while all others are unconstrained.
            if scale.score.value(for: record) <= 5 {
                XCTAssertEqualFormatters(scale.formatter, .bracketed)
            }
            else if scale.identifier != .hypnability {
                XCTAssertEqualFormatters(scale.formatter, .integer)
            }
            else {
                XCTAssertEqualFormatters(scale.formatter, .percentage)
            }
        }
    }
}


func XCTAssertEqualFormatters(_ formatter: AnalysisScoreFormatter,
                              _ expected: AnalysisScoreFormatter,
                              file: StaticString = #file, line: UInt = #line) {

    for score in scoreSamples {
        XCTAssertEqual(formatter.format(score), expected.format(score), file: file, line: line)
    }
}


fileprivate let scoreSamples: [Double] = [
    0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5,
    10, 15, 20, 25, 30, 35, 40, 45
]
