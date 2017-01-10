import Foundation

enum RecordsListViewControllerGrouping {
    case alphabetical
    case flat
}


extension RecordsListViewControllerGrouping {
    func group(_ records: [TestRecordProtocol]) -> Grouping<TestRecordsGroup> {
        switch self {
        case .alphabetical:
            return makeTestRecordGroups(from: records.groupByEqualName())

        case .flat:
            return makeTestRecordGroups(from: records)
        }
    }
}
