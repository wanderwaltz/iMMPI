import Foundation

/// A non-empty collection of records with a certain record selected as a 'primary' one
/// (mostly for displaying in the UI).
///
/// This non-emptiness enforced by the type system is what differs this type from just Grouping<Record>.
/// See `init?(_ group: Grouping<Record>)`, it returns `nil` only for empty groupings.
struct RecordsGroup {
    let primaryRecord: Record
    let allRecords: [Record]
}


extension RecordsGroup {
    var personName: String {
        return primaryRecord.indexItem.personName
    }

    var containsSingleRecord: Bool {
        return allRecords.count == 1
    }
}


extension RecordsGroup {
    init(single record: Record) {
        self.init(primaryRecord: record, allRecords: [record])
    }
}


extension RecordsGroup {
    init?(_ group: Grouping<Record>) {
        if group.allItems.count == 1 {
            self.init(single: group.allItems.first!)
            return
        }

        guard let record = group.allItems.max(by: { $0.date < $1.date }) else {
            return nil
        }

        self.init(primaryRecord: record, allRecords: group.allItems)
    }
}


func makeRecordGroups(from records: [Record]) -> Grouping<RecordsGroup> {
    let groups = records.compactMap({ RecordsGroup(single: $0) })
    return Grouping(items: groups, areInIncreasingOrder: { $0.primaryRecord.date > $1.primaryRecord.date })
}


func makeRecordGroups(from grouping: Grouping<Record>) -> Grouping<RecordsGroup> {
    return grouping.sections.compactMap({ section in
        RecordsGroup(
            Grouping(
                items: section.items,
                areInIncreasingOrder: { $0.date > $1.date }
            )
        )
    }).groupAlphabetically(by: { $0.personName })
}
