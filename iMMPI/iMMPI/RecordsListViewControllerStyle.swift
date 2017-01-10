import UIKit

struct RecordsListViewControllerStyle {
    fileprivate init(updateCell: @escaping (UITableViewCell, TestRecordsGroup) -> (),
                     makeNewRecord: @escaping () -> TestRecordProtocol) {
        _updateCell = updateCell
        _makeNewRecord = makeNewRecord
    }

    fileprivate let _updateCell: (UITableViewCell, TestRecordsGroup) -> ()
    fileprivate let _makeNewRecord: () -> TestRecordProtocol
}


extension RecordsListViewControllerStyle {
    func update(_ cell: UITableViewCell, with group: TestRecordsGroup) {
        _updateCell(cell, group)
    }


    func makeNewRecord() -> TestRecordProtocol {
        return _makeNewRecord()
    }
}


extension RecordsListViewControllerStyle {
    static let root = RecordsListViewControllerStyle(
        updateCell: { cell, item in
            cell.textLabel?.text = item.record.personName
            cell.detailTextLabel?.text = item.group.isEmpty ? "" : "\(item.group.allItems.count)"
    },
        makeNewRecord: {
            return TestRecord()
    })


    static func nested(basedOn record: TestRecordProtocol) -> RecordsListViewControllerStyle {
        let nameFormatter = AbbreviatedNameFormatter()
        let dateFormatter = DateFormatter.medium

        return RecordsListViewControllerStyle(
            updateCell: { cell, item in
                cell.textLabel?.text = nameFormatter.string(for: item.record.personName)
                cell.detailTextLabel?.text = dateFormatter.string(from: item.record.date)
        },
            makeNewRecord: {
                let clone = record.makeCopy()
                clone.date = Date()
                return clone
        })
    }
}
