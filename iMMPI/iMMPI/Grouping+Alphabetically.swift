import Foundation

extension Array {
    func groupAlphabetically(by title: @escaping (Element) -> String) -> Grouping<Element> {
        return Grouping(
            items: self,
            areInIncreasingOrder: { title($0) < title($1) },
            sectionDescriptor: SectionDescriptor(
                itemsBelongToSameSection: { title($0).uppercasedFirstCharacter == title($1).uppercasedFirstCharacter },
                sectionTitleForItem: { title($0).uppercasedFirstCharacter }
            )
        )
    }
}
