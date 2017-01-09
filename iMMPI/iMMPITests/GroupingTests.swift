import XCTest
@testable import iMMPI

final class GroupingTests: XCTestCase {
    let descriptor = SectionDescriptor<String>(
        itemsBelongToSameSection: { l, r in
            return l.uppercasedFirstCharacter == r.uppercasedFirstCharacter
    },
        sectionTitleForItem: { item in
            return item.uppercasedFirstCharacter
    })


    func testThat__grouping_all_items_array_is_sorted() {
        let grouping = Grouping(items: ["b", "c", "a", "d"], areInIncreasingOrder: <, sectionDescriptor: descriptor)
        XCTAssertEqual(grouping.allItems, ["a", "b", "c", "d"])
    }


    func testThat__grouping_splits_into_sections_according_to_descriptor() {
        let items = ["b", "c", "a", "d"]
        let sortedItems = items.sorted()

        let grouping = Grouping(items: items, areInIncreasingOrder: <, sectionDescriptor: descriptor)
        XCTAssertTrue(sortedItems.split(with: descriptor) == grouping.sections)
    }
}


func == <Item: Equatable>(left: Section<Item>, right: Section<Item>) -> Bool {
    return left.title == right.title && left.items == right.items
}


func == <Item: Equatable>(left: [Section<Item>], right: [Section<Item>]) -> Bool {
    guard left.count == right.count else {
        return false
    }

    for i in 0..<left.count {
        guard left[i] == right[i] else {
            return false
        }
    }

    return true
}
