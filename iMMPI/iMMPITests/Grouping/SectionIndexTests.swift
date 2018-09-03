import XCTest
@testable import iMMPI

final class SectionIndexTests: XCTestCase {
    func testThat__it_retains_section_index_titles() {
        XCTAssertEqual(SectionIndex(indexTitles: ["A", "B", "C"]).indexTitles, ["A", "B", "C"])
    }


    func testThat__it_returns_zero_for_unknown_index_title() {
        let index = SectionIndex(indexTitles: ["A", "B", "C"])
        XCTAssertEqual(index.section(forIndexTitle: "Q"), 0)
    }


    func testThat__it_returns_index_of_known_section_index_title() {
        let index = SectionIndex(indexTitles: ["A", "B", "C"])

        XCTAssertEqual(index.section(forIndexTitle: "A"), 0)
        XCTAssertEqual(index.section(forIndexTitle: "B"), 1)
        XCTAssertEqual(index.section(forIndexTitle: "C"), 2)
        XCTAssertEqual(index.section(forIndexTitle: "B"), 1)
        XCTAssertEqual(index.section(forIndexTitle: "A"), 0)
    }


    func testThat__it_returns_first_index_if_section_index_title_repeats() {
        let index = SectionIndex(indexTitles: ["A", "B", "A"])
        XCTAssertEqual(index.section(forIndexTitle: "A"), 0)
        XCTAssertEqual(index.section(forIndexTitle: "B"), 1)
        XCTAssertEqual(index.section(forIndexTitle: "A"), 0)
    }
}
