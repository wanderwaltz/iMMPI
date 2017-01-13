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


    func testThat__grouping_with_items_is_not_empty() {
        let grouping = Grouping(items: ["b", "c", "a", "d"], areInIncreasingOrder: <, sectionDescriptor: descriptor)
        XCTAssertFalse(grouping.isEmpty)
    }


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


    func test__initializing_with_a_single_section() {
        let grouping = Grouping(items: ["b", "c", "a", "d"], areInIncreasingOrder: <)

        XCTAssertEqual(grouping.allItems, ["a", "b", "c", "d"])
        XCTAssertEqual(grouping.sections.count, 1)
        XCTAssertEqual(grouping.sections.first!.items, grouping.allItems)
        XCTAssertEqual(grouping.sections.first!.title, "")
    }


    func test__initializing_with_a_single_section_cutom_name() {
        let grouping = Grouping(items: ["b", "c", "a", "d"], areInIncreasingOrder: <, sectionTitle: "qwerty")
        XCTAssertEqual(grouping.sections.first!.title, "qwerty")
    }


    func testThat__empty_grouping__has_no_items() {
        XCTAssertTrue(Grouping<String>.empty.allItems.isEmpty)
    }


    func testThat__empty_grouping__has_no_sections() {
        XCTAssertTrue(Grouping<String>.empty.sections.isEmpty)
    }


    func testThat__empty_grouping__is_empty() {
        XCTAssertTrue(Grouping<String>.empty.isEmpty)
    }


    func testThat__numberOfSections__returns_sections_count() {
        let grouping = Grouping(items: ["b", "c", "a", "d"], areInIncreasingOrder: <, sectionDescriptor: descriptor)
        XCTAssertEqual(grouping.numberOfSections, grouping.sections.count)
        XCTAssertGreaterThan(grouping.numberOfSections, 0)
    }


    func testThat__empty_grouping__has_zero_numberOfSections() {
        XCTAssertEqual(Grouping<String>.empty.numberOfSections, 0)
    }


    func testThat__number_of_items_in_section__returns_zero_for_invalid_indices() {
        let grouping = Grouping(items: ["b", "c", "a", "d"], areInIncreasingOrder: <, sectionDescriptor: descriptor)
        XCTAssertEqual(grouping.numberOfItems(inSection: -1), 0)
        XCTAssertEqual(grouping.numberOfItems(inSection: 100), 0)

        XCTAssertEqual(Grouping<String>.empty.numberOfItems(inSection: -1), 0)
        XCTAssertEqual(Grouping<String>.empty.numberOfItems(inSection: 0), 0)
        XCTAssertEqual(Grouping<String>.empty.numberOfItems(inSection: 1), 0)
    }


    func testThat__number_of_items_in_section__returns_valid_values_for_valid_indices() {
        let grouping = Grouping(items: ["a", "b", "b", "b", "c", "c"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        XCTAssertEqual(grouping.numberOfItems(inSection: 0), 1)
        XCTAssertEqual(grouping.numberOfItems(inSection: 1), 3)
        XCTAssertEqual(grouping.numberOfItems(inSection: 2), 2)
    }


    func testThat__title_for_section__returns_nil_for_invalid_indices() {
        let grouping = Grouping(items: ["b", "c", "a", "d"], areInIncreasingOrder: <, sectionDescriptor: descriptor)
        XCTAssertNil(grouping.title(forSection: -1))
        XCTAssertNil(grouping.title(forSection: 100))

        XCTAssertNil(Grouping<String>.empty.title(forSection: -1))
        XCTAssertNil(Grouping<String>.empty.title(forSection: 0))
        XCTAssertNil(Grouping<String>.empty.title(forSection: 1))
    }


    func testThat__title_for_section__returns_section_titles_for_valid_indices() {
        let grouping = Grouping(items: ["a", "b", "b", "b", "c", "c"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        XCTAssertEqual(grouping.title(forSection: 0), "A")
        XCTAssertEqual(grouping.title(forSection: 1), "B")
        XCTAssertEqual(grouping.title(forSection: 2), "C")
    }


    func testThat__item_at_index_path__returns_nil_for_invalid_index_paths() {
        let grouping = Grouping(items: ["b", "c", "a", "d"], areInIncreasingOrder: <, sectionDescriptor: descriptor)
        XCTAssertNil(grouping.item(at: IndexPath(row: -1, section: 0)))
        XCTAssertNil(grouping.item(at: IndexPath(row: 0, section: 100)))
        XCTAssertNil(grouping.item(at: IndexPath(row: -1, section: -1)))
        XCTAssertNil(grouping.item(at: IndexPath(row: 100, section: 0)))

        XCTAssertNil(Grouping<String>.empty.item(at: IndexPath(row: 0, section: 0)))
        XCTAssertNil(Grouping<String>.empty.item(at: IndexPath(row: -1, section: 1)))
        XCTAssertNil(Grouping<String>.empty.item(at: IndexPath(row: 1, section: 0)))
    }


    func testThat__item_at_index_path__returns_items_for_valid_indices() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        XCTAssertEqual(grouping.item(at: IndexPath(row: 0, section: 0)), "abba")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 0, section: 1)), "bad")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 1, section: 1)), "boris")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 2, section: 1)), "burger")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 0, section: 2)), "cake")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 1, section: 2)), "corn")
    }


    func testThat__index_path_of_item__returns_index_path_if_found() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        XCTAssertEqual(grouping.indexPathOfItem(matching: { $0 == "burger" }), IndexPath(row: 2, section: 1))
    }


    func testThat__index_path_of_item__returns_nil_if_not_found() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        XCTAssertNil(grouping.indexPathOfItem(matching: { $0 == "burger123" }))
    }


    func testThat__enumerated__returns_all_items_with_index_paths() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        let enumerated = Array(grouping.enumerated())

        XCTAssertEqual(enumerated[0].0, IndexPath(row: 0, section: 0))
        XCTAssertEqual(enumerated[1].0, IndexPath(row: 0, section: 1))
        XCTAssertEqual(enumerated[2].0, IndexPath(row: 1, section: 1))
        XCTAssertEqual(enumerated[3].0, IndexPath(row: 2, section: 1))
        XCTAssertEqual(enumerated[4].0, IndexPath(row: 0, section: 2))
        XCTAssertEqual(enumerated[5].0, IndexPath(row: 1, section: 2))

        XCTAssertEqual(enumerated[0].1, "abba")
        XCTAssertEqual(enumerated[1].1, "bad")
        XCTAssertEqual(enumerated[2].1, "boris")
        XCTAssertEqual(enumerated[3].1, "burger")
        XCTAssertEqual(enumerated[4].1, "cake")
        XCTAssertEqual(enumerated[5].1, "corn")
    }


    func testThat__map_keeps_items_count() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        let mapped = grouping.map { $0.uppercased() }
        XCTAssertEqual(grouping.allItems.count, mapped.allItems.count)
    }


    func testThat__map_keeps_sections_count() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        let mapped = grouping.map { $0.uppercased() }
        XCTAssertEqual(grouping.sections.count, mapped.sections.count)
    }


    func testThat__map_keeps_items_in_sections_count() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        let mapped = grouping.map { $0.uppercased() }

        for i in 0..<grouping.sections.count {
            XCTAssertEqual(grouping.sections[i].items.count, mapped.sections[i].items.count)
        }
    }


    func testThat__map__maps_items() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        let mapped = grouping.map { $0.uppercased() }

        XCTAssertEqual(mapped.allItems, ["ABBA", "BAD", "BORIS", "BURGER", "CAKE", "CORN"])
    }


    func testThat__map__maps_items_in_sections() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        let mapped = grouping.map { $0.uppercased() }


        XCTAssertEqual(mapped.item(at: IndexPath(row: 0, section: 0)), "ABBA")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 0, section: 1)), "BAD")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 1, section: 1)), "BORIS")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 2, section: 1)), "BURGER")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 0, section: 2)), "CAKE")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 1, section: 2)), "CORN")
    }


    func testThat__map__keeps_grouping_structure_even_if_mapping_items_prior_would_break_it() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        let mapped = grouping.map { _ in "Q" }

        XCTAssertEqual(mapped.sections.count, grouping.sections.count)
        XCTAssertEqual(mapped.sections[0].items.count, grouping.sections[0].items.count)
        XCTAssertEqual(mapped.sections[1].items.count, grouping.sections[1].items.count)
        XCTAssertEqual(mapped.sections[2].items.count, grouping.sections[2].items.count)

        XCTAssertEqual(mapped.item(at: IndexPath(row: 0, section: 0)), "Q")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 0, section: 1)), "Q")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 1, section: 1)), "Q")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 2, section: 1)), "Q")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 0, section: 2)), "Q")
        XCTAssertEqual(mapped.item(at: IndexPath(row: 1, section: 2)), "Q")
    }


    func testThat__map__does_not_alter_section_titles() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        let mapped = grouping.map { _ in "Q" }

        XCTAssertEqual(mapped.sections[0].title, "A")
        XCTAssertEqual(mapped.sections[1].title, "B")
        XCTAssertEqual(mapped.sections[2].title, "C")
    }


    func testThat__makeIndex__uses_first_letters_of_section_titles() {
        let grouping = Grouping(items: ["abba", "boris", "burger", "bad", "corn", "cake"],
                                areInIncreasingOrder: <, sectionDescriptor: descriptor)

        XCTAssertEqual(grouping.makeIndex().indexTitles, ["A","B","C"])
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
