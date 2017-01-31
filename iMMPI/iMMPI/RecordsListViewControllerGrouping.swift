import Foundation

enum RecordsListViewControllerGrouping {
    case alphabetical
    case flat
}


extension RecordsListViewControllerGrouping {
    func group(_ records: [RecordProtocol]) -> Grouping<RecordsGroup> {
        switch self {
        case .alphabetical:
            return makeRecordGroups(from: groupByEqualName(records))

        case .flat:
            return makeRecordGroups(from: records)
        }
    }
}
