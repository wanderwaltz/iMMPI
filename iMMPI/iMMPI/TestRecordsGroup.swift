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
                areInIncreasingOrder: { _ in false },
                sectionDescriptor: SectionDescriptor(
                    itemsBelongToSameSection: { _ in true },
                    sectionTitleForItem: { $0.personName }
                )
            )
        )
    }
}
