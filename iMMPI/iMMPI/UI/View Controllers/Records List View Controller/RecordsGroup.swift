import Foundation

final class RecordsGroup {
    let record: RecordProtocol
    let group: Grouping<RecordsGroup>

    init(record: RecordProtocol, group: Grouping<RecordsGroup>) {
        self.record = record
        self.group = group
    }
}


extension RecordsGroup: PersonNameConvertible {
    var personName: String {
        return record.personName
    }

    var containsSingleRecord: Bool {
        return group.isEmpty
    }

    func allRecords() -> [RecordProtocol] {
        var records = [record]

        for subgroup in group.allItems {
            records.append(contentsOf: subgroup.allRecords())
        }

        return records
    }
}


extension RecordsGroup {
    convenience init(single record: RecordProtocol) {
        self.init(record: record, group: .empty)
    }
}


extension RecordsGroup {
    convenience init?(_ group: Grouping<RecordProtocol>) {
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


func makeRecordGroups(from records: [RecordProtocol]) -> Grouping<RecordsGroup> {
    let groups = records.compactMap({ RecordsGroup(single: $0) })
    return Grouping(items: groups, areInIncreasingOrder: { $0.record.date > $1.record.date })
}


func makeRecordGroups(from grouping: Grouping<RecordProtocol>) -> Grouping<RecordsGroup> {
    return grouping.sections.compactMap({ section in
        RecordsGroup(
            Grouping(
                items: section.items,
                areInIncreasingOrder: { $0.date > $1.date }
            )
        )
    }).groupAlphabetically(by: { $0.personName })
}
