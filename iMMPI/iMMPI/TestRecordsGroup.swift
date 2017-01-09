import Foundation

struct TestRecordsGroup {
    let record: TestRecordProtocol
    let group: Grouping<TestRecordsGroup>

    init(record: TestRecordProtocol, group: Grouping<TestRecordsGroup>) {
        self.record = record
        self.group = group
    }
}


extension TestRecordsGroup {
    init(single record: TestRecordProtocol) {
        self.init(record: record, group: .empty)
    }
}


extension TestRecordsGroup {
    init?(_ group: Grouping<TestRecordProtocol>) {
        guard let record = group.allItems.max(by: { $0.date < $1.date }) else {
            return nil
        }

        self.init(record: record, group: group.map { TestRecordsGroup(single: $0) })
    }
}
