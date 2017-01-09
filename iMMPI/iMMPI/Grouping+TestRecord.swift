import Foundation

extension Array where Element: PersonNameConvertible {
    func groupByEqualName() -> Grouping<Element> {
        return Grouping(
            items: self,
            areInIncreasingOrder: { $0.personName < $1.personName },
            sectionDescriptor: SectionDescriptor(
                itemsBelongToSameSection: { $0.personName == $1.personName },
                sectionTitleForItem: { $0.personName }
            )
        )
    }
}
