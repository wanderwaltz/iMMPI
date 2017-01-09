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
