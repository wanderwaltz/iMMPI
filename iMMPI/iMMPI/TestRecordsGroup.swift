import Foundation

struct TestRecordsGroup {
    let title: String
    let records: Grouping<TestRecordProtocol>

    init(title: String, records: Grouping<TestRecordProtocol>) {
        self.title = title
        self.records = records
    }
}


extension TestRecordsGroup {
    init(single record: TestRecordProtocol) {
        self.init(
            title: record.personName,
            records: Grouping(
                items: [record],
                areInIncreasingOrder: Constant.bool(false),
                sectionDescriptor: SectionDescriptor(
                    itemsBelongToSameSection: Constant.bool(true),
                    sectionTitleForItem: Constant.string(record.personName)
                )
            )
        )
    }
}
