import Foundation

enum RecordsListViewControllerGrouping {
    case alphabetical
    case flat
}


extension RecordsListViewControllerGrouping {
    func group(_ records: [RecordProtocol]) -> Grouping<RecordsGroup> {
        switch self {
        case .alphabetical:
            return makeRecordGroups(from: records.groupByEqualName())

        case .flat:
            return makeRecordGroups(from: records)
        }
    }
}
