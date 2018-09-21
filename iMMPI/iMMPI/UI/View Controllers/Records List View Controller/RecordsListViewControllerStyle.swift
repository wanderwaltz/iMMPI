import UIKit

struct RecordsListViewControllerStyle {
    fileprivate init(updateCell: @escaping (UITableViewCell, RecordsGroup) -> (),
                     makeNewRecord: @escaping () -> Record) {
        _updateCell = updateCell
        _makeNewRecord = makeNewRecord
    }

    fileprivate let _updateCell: (UITableViewCell, RecordsGroup) -> ()
    fileprivate let _makeNewRecord: () -> Record
}


extension RecordsListViewControllerStyle {
    func update(_ cell: UITableViewCell, with group: RecordsGroup) {
        _updateCell(cell, group)
    }


    func makeNewRecord() -> Record {
        return _makeNewRecord()
    }
}


extension RecordsListViewControllerStyle {
    static let root = RecordsListViewControllerStyle(
        updateCell: { cell, item in
            cell.textLabel?.text = item.primaryRecord.indexItem.personName
            cell.detailTextLabel?.text = item.containsSingleRecord ? "" : "\(item.allRecords.count)"
            cell.accessoryType = .detailDisclosureButton
        },
        makeNewRecord: {
            return Record()
        }
    )


    static func nested(basedOn record: Record) -> RecordsListViewControllerStyle {
        let nameFormatter = AbbreviatedNameFormatter()
        let dateFormatter = DateFormatter.medium

        return RecordsListViewControllerStyle(
            updateCell: { cell, item in
                let indexItem = item.primaryRecord.indexItem
                cell.textLabel?.text = nameFormatter.string(for: indexItem.personName)
                cell.detailTextLabel?.text = dateFormatter.string(from: indexItem.date)
                cell.accessoryType = .detailDisclosureButton
            },
            makeNewRecord: {
                var clone = record
                clone.date = Date()
                return clone
            }
        )
    }
}
