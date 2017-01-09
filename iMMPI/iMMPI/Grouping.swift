import Foundation

struct Grouping<Item> {
    let allItems: [Item]
    let sections: [Section<Item>]

    init(items: [Item],
         areInIncreasingOrder: (Item, Item) -> Bool,
         sectionDescriptor: SectionDescriptor<Item>) {

        let sortedItems = items.sorted(by: areInIncreasingOrder)

        self.init(allItems: sortedItems, sections: sortedItems.split(with: sectionDescriptor))
    }


    fileprivate init(allItems: [Item], sections: [Section<Item>]) {
        self.allItems = allItems
        self.sections = sections
    }
}


extension Grouping {
    var isEmpty: Bool {
        return allItems.isEmpty
    }

    static var empty: Grouping {
        return Grouping(
            items: [],
            areInIncreasingOrder: Constant.bool(false),
            sectionDescriptor: SectionDescriptor(
                itemsBelongToSameSection: Constant.bool(true),
                sectionTitleForItem: Constant.string("")
            )
        )
    }
}


extension Grouping {
    func map<T>(_ mapping: (Item) -> T) -> Grouping<T> {
        return Grouping<T>(allItems: allItems.map(mapping), sections: sections.map({ $0.map(mapping) }))
    }
}
