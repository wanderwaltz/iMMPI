import XCTest
@testable import iMMPI

final class AnalyserScaleIdentifiersTests: XCTestCase {
    var analyser: Analyser!

    override func setUp() {
        super.setUp()
        analyser = Analyser()
    }

    func testThat__all_scales_have_unique_identifiers() {
        let identifiers = Set(analyser.scales.map({ $0.identifier }))

        XCTAssertEqual(identifiers.count, analyser.scales.count)
    }

    func testThat__all_scales_have_unique_titles() {
        let titles = Set(analyser.scales.map({ $0.title }))

        XCTAssertEqual(titles.count, analyser.scales.count)
    }
}
