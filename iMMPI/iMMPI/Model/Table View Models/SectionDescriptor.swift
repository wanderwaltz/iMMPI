import Foundation
import Utils

struct SectionDescriptor<Item> {
    let itemsBelongToSameSection: (Item, Item) -> Bool
    let sectionTitleForItem: (Item) -> String
}


extension SectionDescriptor {
    static func singleSection(named title: String) -> SectionDescriptor {
        return SectionDescriptor(
            itemsBelongToSameSection: Constant.value(true),
            sectionTitleForItem: Constant.value(title)
        )
    }
}


extension Array {
    func split(with descriptor: SectionDescriptor<Element>) -> [Section<Element>] {
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
