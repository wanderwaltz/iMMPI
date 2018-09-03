import UIKit

struct RecordsListViewControllerStyle {
    fileprivate init(updateCell: @escaping (UITableViewCell, RecordsGroup) -> (),
                     makeNewRecord: @escaping () -> RecordProtocol) {
        _updateCell = updateCell
        _makeNewRecord = makeNewRecord
    }

    fileprivate let _updateCell: (UITableViewCell, RecordsGroup) -> ()
    fileprivate let _makeNewRecord: () -> RecordProtocol
}


extension RecordsListViewControllerStyle {
    func update(_ cell: UITableViewCell, with group: RecordsGroup) {
        _updateCell(cell, group)
    }


    func makeNewRecord() -> RecordProtocol {
        return _makeNewRecord()
    }
}


extension RecordsListViewControllerStyle {
    static let root = RecordsListViewControllerStyle(
        updateCell: { cell, item in
            cell.textLabel?.text = item.record.personName
            cell.detailTextLabel?.text = item.group.isEmpty ? "" : "\(item.group.allItems.count)"
            cell.accessoryType = .detailDisclosureButton
    },
        makeNewRecord: {
            return Record()
    })


    static func nested(basedOn record: RecordProtocol) -> RecordsListViewControllerStyle {
        let nameFormatter = AbbreviatedNameFormatter()
        let dateFormatter = DateFormatter.medium

        return RecordsListViewControllerStyle(
            updateCell: { cell, item in
                cell.textLabel?.text = nameFormatter.string(for: item.record.personName)
                cell.detailTextLabel?.text = dateFormatter.string(from: item.record.date)
                cell.accessoryType = .detailDisclosureButton
        },
            makeNewRecord: {
                let clone = record.makeCopy()
                clone.date = Date()
                return clone
        })
    }
}
