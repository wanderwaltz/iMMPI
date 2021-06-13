import UIKit
import Utils

public final class Grouping<Item> {
    public let allItems: [Item]
    public let sections: [Section<Item>]
    public let indexPaths: [IndexPath]

    public convenience init(
        items: [Item],
        areInIncreasingOrder: (Item, Item) -> Bool,
        sectionDescriptor: SectionDescriptor<Item>
    ) {
        let sortedItems = items.sorted(by: areInIncreasingOrder)

        self.init(
            allItems: sortedItems,
            sections: sortedItems.split(with: sectionDescriptor)
        )
    }

    private init(allItems: [Item], sections: [Section<Item>]) {
        self.allItems = allItems
        self.sections = sections
        self.indexPaths = Array(sections.enumerated().map({ sectionIndex, section in
            return section.items.enumerated().map({ itemIndex, _ in
                return IndexPath(row: itemIndex, section: sectionIndex)
            })
        }).joined())
    }
}


extension Grouping {
    public var numberOfSections: Int {
        return sections.count
    }

    public func numberOfItems(inSection section: Int) -> Int {
        guard 0 <= section && section < sections.count else {
            return 0
        }

        return sections[section].items.count
    }

    public func title(forSection section: Int) -> String? {
        guard 0 <= section && section < sections.count else {
            return nil
        }

        return sections[section].title
    }

    public func item(at indexPath: IndexPath) -> Item? {
        guard sections.indices ~= indexPath.section else {
            return nil
        }

        let section = sections[indexPath.section]

        guard section.items.indices ~= indexPath.row else {
            return nil
        }

        return section.items[indexPath.row]
    }

    public func indexPathOfItem(matching predicate: (Item) -> Bool) -> IndexPath? {
        for (indexPath, item) in enumerated() {
            if predicate(item) {
                return indexPath
            }
        }

        return nil
    }

    public func enumerated() -> AnySequence<(IndexPath, Item)> {
        return AnySequence(indexPaths.map({ ($0, item(at: $0)!) }))
    }
}


extension Grouping {
    public var isEmpty: Bool {
        return allItems.isEmpty
    }

    public static var empty: Grouping {
        return Grouping(
            items: [],
            areInIncreasingOrder: Constant.value(false),
            sectionDescriptor: .singleSection(named: "")
        )
    }

    public convenience init(
        items: [Item],
        areInIncreasingOrder: (Item, Item) -> Bool,
        sectionTitle: String = ""
    ) {
        self.init(
            items: items,
            areInIncreasingOrder: areInIncreasingOrder,
            sectionDescriptor: .singleSection(named: sectionTitle)
        )
    }
}

extension Grouping {
    public func map<T>(_ mapping: (Item) -> T) -> Grouping<T> {
        return Grouping<T>(
            allItems: allItems.map(mapping),
            sections: sections.map({ $0.map(mapping) })
        )
    }
}

extension Grouping {
    public func makeIndex() -> SectionIndex {
        return SectionIndex(
            indexTitles: sections.map { $0.title.uppercasedFirstCharacter }
        )
    }
}
