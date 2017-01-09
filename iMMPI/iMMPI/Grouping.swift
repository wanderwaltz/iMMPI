import Foundation

struct Grouping<Item> {
    let allItems: [Item]
    let sections: [Section<Item>]

    init(items: [Item],
         areInIncreasingOrder: (Item, Item) -> Bool,
         sectionDescriptor: SectionDescriptor<Item>) {

        let sortedItems = items.sorted(by: areInIncreasingOrder)

        allItems = sortedItems
        sections = sortedItems.split(with: sectionDescriptor)
    }
}


extension Grouping {
    var isEmpty: Bool {
        return allItems.isEmpty
    }

    static var empty: Grouping {
        return Grouping(
            items: [],
            areInIncreasingOrder: { _ in false },
            sectionDescriptor: SectionDescriptor(
                itemsBelongToSameSection: { _ in true },
                sectionTitleForItem: { _ in "" }
            )
        )
    }
}
