import XCTest
@testable import iMMPI

final class NewAnalyserScaleIdentifiersTests: XCTestCase {
    var analyser: NewAnalyser!

    override func setUp() {
        super.setUp()
        analyser = NewAnalyser()
    }

    func testThat__all_nested_scales_have_unique_identifiers() {
        let identifiers = Set(analyser.scales.map({ $0.identifier }))

        XCTAssertEqual(identifiers.count, analyser.scales.count)
    }
}
