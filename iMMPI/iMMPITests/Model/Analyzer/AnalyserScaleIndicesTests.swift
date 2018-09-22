import XCTest
@testable import iMMPI

final class AnalyserScaleIndicesTests: XCTestCase {
    var analyser: Analyser!
    var scales: [AnalysisScale]!

    override func setUp() {
        super.setUp()
        analyser = Analyser()
        scales = analyser.scales.filter({ $0.identifier.nesting > 0 })
    }

    func testThat__all_nested_scales_have_unique_indices() {
        let maleIndices = Set(scales.map({ $0.index.value(for: .male) }))
        let femaleIndices = Set(scales.map({ $0.index.value(for: .female) }))

        XCTAssertEqual(maleIndices.count, scales.count)
        XCTAssertEqual(femaleIndices.count, scales.count)
    }
}
