import Foundation

final class TestRecordsGroup: NSObject {
    let record: TestRecordProtocol
    let group: Grouping<TestRecordsGroup>

    init(record: TestRecordProtocol, group: Grouping<TestRecordsGroup>) {
        self.record = record
        self.group = group
        super.init()
    }
}


extension TestRecordsGroup: PersonNameConvertible {
    var personName: String {
        return record.personName
    }


    func allRecords() -> [TestRecordProtocol] {
        var records = [record]

        for subgroup in group.allItems {
            records.append(contentsOf: subgroup.allRecords())
        }

        return records
    }
}


extension TestRecordsGroup {
    convenience init(single record: TestRecordProtocol) {
        self.init(record: record, group: .empty)
    }
}


extension TestRecordsGroup {
    convenience init?(_ group: Grouping<TestRecordProtocol>) {
        if group.allItems.count == 1 {
            self.init(single: group.allItems.first!)
            return
        }

        guard let record = group.allItems.max(by: { $0.date < $1.date }) else {
            return nil
        }

        self.init(record: record, group: group.map { TestRecordsGroup(single: $0) })
    }
}


func makeTestRecordGroups(from records: [TestRecordProtocol]) -> Grouping<TestRecordsGroup> {
    let groups = records.flatMap({ TestRecordsGroup(single: $0) })
    return Grouping(items: groups, areInIncreasingOrder: { $0.record.date < $1.record.date })
}


func makeTestRecordGroups(from grouping: Grouping<TestRecordProtocol>) -> Grouping<TestRecordsGroup> {
    return grouping.sections.flatMap({ section in
        TestRecordsGroup(
            Grouping(
                items: section.items,
                areInIncreasingOrder: { $0.date < $1.date }
            )
        )
    }).groupAlphabetically(by: { $0.personName })
}
