import UIKit

final class Grouping<Item>: NSObject {
    let allItems: [Item]
    let sections: [Section<Item>]
    let indexPaths: [IndexPath]

    convenience init(items: [Item],
         areInIncreasingOrder: (Item, Item) -> Bool,
         sectionDescriptor: SectionDescriptor<Item>) {

        let sortedItems = items.sorted(by: areInIncreasingOrder)

        self.init(allItems: sortedItems, sections: sortedItems.split(with: sectionDescriptor))
    }


    fileprivate init(allItems: [Item], sections: [Section<Item>]) {
        self.allItems = allItems
        self.sections = sections
        self.indexPaths = Array(sections.enumerated().map({ sectionIndex, section in
            return section.items.enumerated().map({ itemIndex, _ in
                return IndexPath(row: itemIndex, section: sectionIndex)
            })
        }).joined())

        super.init()
    }
}


extension Grouping {
    var numberOfSections: Int {
        return sections.count
    }


    func numberOfItems(inSection section: Int) -> Int {
        guard 0 <= section && section < sections.count else {
            return 0
        }

        return sections[section].items.count
    }


    func title(forSection section: Int) -> String? {
        guard 0 <= section && section < sections.count else {
            return nil
        }

        return sections[section].title
    }


    func item(at indexPath: IndexPath) -> Item? {
        guard sections.indices ~= indexPath.section else {
            return nil
        }

        let section = sections[indexPath.section]

        guard section.items.indices ~= indexPath.row else {
            return nil
        }

        return section.items[indexPath.row]
    }


    func indexPathOfItem(matching predicate: (Item) -> Bool) -> IndexPath? {
        for (indexPath, item) in enumerated() {
            if predicate(item) {
                return indexPath
            }
        }

        return nil
    }


    func enumerated() -> AnySequence<(IndexPath, Item)> {
        return AnySequence(indexPaths.map({ ($0, item(at: $0)!) }))
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
            sectionDescriptor: .singleSection(named: "")
        )
    }


    convenience init(items: [Item], areInIncreasingOrder: (Item, Item) -> Bool, sectionTitle: String = "") {
        self.init(
            items: items,
            areInIncreasingOrder: areInIncreasingOrder,
            sectionDescriptor: .singleSection(named: "")
        )
    }


    convenience init(sections: [Section<Item>]) {
        self.init(
            allItems: Array(sections.map { $0.items }.joined()),
            sections: sections
        )
    }
}


extension Grouping {
    func map<T>(_ mapping: (Item) -> T) -> Grouping<T> {
        return Grouping<T>(allItems: allItems.map(mapping), sections: sections.map({ $0.map(mapping) }))
    }
}


extension Grouping {
    func makeIndex() -> SectionIndex {
        return SectionIndex(indexTitles: sections.map { $0.title.uppercasedFirstCharacter })
    }
}
