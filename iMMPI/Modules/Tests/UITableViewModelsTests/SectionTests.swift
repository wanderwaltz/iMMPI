import XCTest
import UITableViewModels

final class SectionTests: XCTestCase {
    func testThat__section_retains_its_title() {
        XCTAssertEqual(Section<Int>(title: "qwerty", items: []).title, "qwerty")
        XCTAssertEqual(Section<Int>(title: "asdfg", items: []).title, "asdfg")
    }


    func testThat__section_retains_its_items() {
        XCTAssertEqual(Section<Int>(title: "", items: [1,2,4]).items, [1,2,4])
        XCTAssertEqual(Section<Int>(title: "", items: [5,8,9]).items, [5,8,9])
    }


    func testThat__section_maps_its_items() {
        XCTAssertEqual(Section<Int>(title: "", items: [1,2,3]).map({ String(describing: $0) }).items,
                       ["1","2","3"])
    }
}
