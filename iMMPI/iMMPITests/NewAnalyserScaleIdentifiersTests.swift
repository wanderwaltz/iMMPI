import XCTest
@testable import iMMPI

final class NewAnalyserScaleIdentifiersTests: XCTestCase {
    var analyser: NewAnalyser!
    var scales: [AnalysisScale]!

    override func setUp() {
        super.setUp()
        analyser = NewAnalyser()
        scales = analyser.scales.filter({ $0.identifier.nesting > 0 })
    }

    func testThat__all_nested_scales_have_unique_identifiers() {
        let identifiers = Set(scales.map({ $0.identifier }))

        XCTAssertEqual(identifiers.count, scales.count)
    }
}
