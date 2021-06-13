import XCTest
import AnalysisTestSamples
@testable import Analysis

final class AnalyserScoreFiltersTests: XCTestCase {
    var analyser: Analyser!

    override func setUp() {
        super.setUp()
        analyser = Analyser()
    }

    func testThat__all_zero_nested_scales_have_never_filter() {
        for scale in analyser.scales {
            if scale.identifier.nesting == 0 {
                XCTAssertEqualFilters(scale.filter, .never)
            }
        }
    }


    func testThat__nonzero_nested_scales_have_proper_filters() {
        let record = TestSamples.record(at: 123)

        for scale in analyser.scales {
            guard scale.identifier.nesting > 0 else {
                continue
            }

            // an indirect way to detect which score computation method is used for the scale;
            // AnalysisScore is closure-based and thus is not comparable, so we use the domain
            // knowledge that bracketed scores are in 0...5 range while all others are unconstrained.
            if scale.score.value(for: record) <= 5 {
                XCTAssertEqualFilters(scale.filter, .bracketed)
            }
            else if scale.identifier != .hypnability {
                XCTAssertEqualFilters(scale.filter, .median)
            }
            else {
                XCTAssertEqualFilters(scale.filter, .never)
            }
        }
    }
}


func XCTAssertEqualFilters(_ filter: AnalysisScoreFilter,
                           _ expected: AnalysisScoreFilter,
                           file: StaticString = #file, line: UInt = #line) {

    for score in scoreSamples {
        XCTAssertEqual(filter.isWithinNorm(score), expected.isWithinNorm(score), file: file, line: line)
    }
}


fileprivate let scoreSamples: [Double] = [
    0.0, 3.5, 5.0, 20.0, 50.0, 60.0
]
