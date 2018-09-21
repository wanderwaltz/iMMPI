import Foundation

struct RecordsGroup {
    let record: Record
    let group: Grouping<RecordsGroup>
}


extension RecordsGroup {
    var personName: String {
        return record.indexItem.personName
    }

    var containsSingleRecord: Bool {
        return group.isEmpty
    }

    func allRecords() -> [Record] {
        var records = [record]
        var identifiers: Set<RecordIdentifier> = [record.identifier]

        // add all nested records without repeats
        for subgroup in group.allItems {
            for record in subgroup.allRecords() {
                if identifiers.contains(record.identifier) == false {
                    identifiers.insert(record.identifier)
                    records.append(record)
                }
            }
        }

        return records
    }
}


extension RecordsGroup {
    init(single record: Record) {
        self.init(record: record, group: .empty)
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

        self.init(record: record, group: group.map { RecordsGroup(single: $0) })
    }
}


func makeRecordGroups(from records: [Record]) -> Grouping<RecordsGroup> {
    let groups = records.compactMap({ RecordsGroup(single: $0) })
    return Grouping(items: groups, areInIncreasingOrder: { $0.record.date > $1.record.date })
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
