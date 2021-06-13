import Foundation
import DataModel

func groupByEqualName(_ items: [RecordProtocol]) -> Grouping<RecordProtocol> {
    return Grouping(
        items: items,
        areInIncreasingOrder: { $0.personName < $1.personName },
        sectionDescriptor: SectionDescriptor(
            itemsBelongToSameSection: { $0.personName == $1.personName },
            sectionTitleForItem: { $0.personName }
        )
    )
}
