import Foundation
import Utils

public struct SectionDescriptor<Item> {
    public let itemsBelongToSameSection: (Item, Item) -> Bool
    public let sectionTitleForItem: (Item) -> String

    public init(
        itemsBelongToSameSection: @escaping (Item, Item) -> Bool,
        sectionTitleForItem: @escaping (Item) -> String
    ) {
        self.itemsBelongToSameSection = itemsBelongToSameSection
        self.sectionTitleForItem = sectionTitleForItem
    }
}


extension SectionDescriptor {
    public static func singleSection(named title: String) -> SectionDescriptor {
        return SectionDescriptor(
            itemsBelongToSameSection: Constant.value(true),
            sectionTitleForItem: Constant.value(title)
        )
    }
}


extension Array {
    public func split(
        with descriptor: SectionDescriptor<Element>
    ) -> [Section<Element>] {
        guard false == self.isEmpty else {
            return []
        }

        var result: [Section<Element>] = []

        var i = 0
        var currentSectionItems: [Element] = []

        let finalizeSection = {
            let title = descriptor.sectionTitleForItem(currentSectionItems.first!)
            result.append(Section(title: title, items: currentSectionItems))
            currentSectionItems = []
        }

        while i < count {
            let currentItem = self[i]

            if currentSectionItems.last == nil
                || descriptor.itemsBelongToSameSection(currentSectionItems.last!, currentItem) {
                currentSectionItems.append(currentItem)
            }
            else {
                finalizeSection()
                currentSectionItems.append(currentItem)
            }

            i += 1
        }

        finalizeSection()

        return result
    }
}
