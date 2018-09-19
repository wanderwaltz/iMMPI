import Foundation

func groupByEqualName(_ items: [Record]) -> Grouping<Record> {
    return Grouping(
        items: items,
        areInIncreasingOrder: { $0.indexItem.personName < $1.indexItem.personName },
        sectionDescriptor: SectionDescriptor(
            itemsBelongToSameSection: { $0.indexItem.personName == $1.indexItem.personName },
            sectionTitleForItem: { $0.indexItem.personName }
        )
    )
}
