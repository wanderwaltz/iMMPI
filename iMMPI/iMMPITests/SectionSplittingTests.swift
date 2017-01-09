import XCTest
@testable import iMMPI

final class SectionSplittingTests: XCTestCase {
    var descriptor = SectionDescriptor<String>(
        itemsBelongToSameSection: { l, r in
            return firstLetterUppercase(l) == firstLetterUppercase(r)
    },
        sectionTitleForItem: { item in
            return firstLetterUppercase(item)
    })


    func testThat__empty_array_is_split_into_empty_sections() {
        XCTAssertTrue([String]().split(with: descriptor).isEmpty)
    }


    func testCase1__all_items_are_placed_into_same_section() {
        let items = [
            "A",
            "a",
            "abc",
            "asdfg",
            "a1",
            "aq"
        ]

        let sections = items.split(with: descriptor)

        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(items, sections.first!.items)
    }


    func testCase2__all_items_are_placed_into_same_section() {
        let items = [
            "D",
            "DD",
            "DDD",
            "DD",
            "D"
        ]

        let sections = items.split(with: descriptor)

        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(items, sections.first!.items)
    }


    func testCase1__splitting_into_two_sections() {
        let items = [
            "A",
            "B"
        ]

        let sections = items.split(with: descriptor)

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections.first!.items, ["A"])
        XCTAssertEqual(sections.last!.items, ["B"])
    }


    func testCase2__splitting_into_two_sections() {
        let items = [
            "A",
            "aa",
            "B",
            "B",
            "BB",
            "BBB"
        ]

        let sections = items.split(with: descriptor)

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections.first!.items, ["A", "aa"])
        XCTAssertEqual(sections.last!.items, ["B", "B", "BB", "BBB"])
    }


    func testCase1__splitting_into_several_sections() {
        let items = [
            "A",
            "a",
            "AAA",
            "B",
            "BB",
            "C",
            "cvbn"
        ]

        let sections = items.split(with: descriptor)

        XCTAssertEqual(sections.count, 3)
        XCTAssertEqual(sections[0].items, ["A", "a", "AAA"])
        XCTAssertEqual(sections[1].items, ["B", "BB"])
        XCTAssertEqual(sections[2].items, ["C", "cvbn"])
    }


    func testCase2__splitting_into_several_sections() {
        let items = [
            "A",
            "a",
            "AAA",
            "B",
            "BB",
            "a",
            "A"
        ]

        let sections = items.split(with: descriptor)

        XCTAssertEqual(sections.count, 3)
        XCTAssertEqual(sections[0].items, ["A", "a", "AAA"])
        XCTAssertEqual(sections[1].items, ["B", "BB"])
        XCTAssertEqual(sections[2].items, ["a", "A"])
    }


    func testCase__section_titles() {
        let items = [
            "apple",
            "Adam",
            "A",
            "Boris",
            "big",
            "Certificate",
            "Split"
        ]

        let sections = items.split(with: descriptor)

        XCTAssertEqual(sections.count, 4)
        XCTAssertEqual(sections[0].title, "A")
        XCTAssertEqual(sections[1].title, "B")
        XCTAssertEqual(sections[2].title, "C")
        XCTAssertEqual(sections[3].title, "S")
    }
}


fileprivate func firstLetterUppercase(_ string: String) -> String {
    guard string.isEmpty == false else {
        return string
    }

    return string.substring(to: string.index(after: string.startIndex)).uppercased()
}
