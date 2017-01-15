import UIKit

extension TableViewCellSource {
    static func `switch`(
        identifier: String = "com.immpi.cells.switch",
        update: @escaping (_ cell: UITableViewCell, _ `switch`: UISwitch, _ data: Data?) -> ()) -> TableViewCellSource {
        return TableViewCellSource(
            register: Constant.void(),
            dequeue: { tableView, data in
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
                    ?? UITableViewCell(style: .default, reuseIdentifier: identifier)

                let `switch` = cell.accessoryView as? UISwitch ?? UISwitch()

                `switch`.sizeToFit()

                if cell.accessoryView != `switch` {
                    cell.accessoryView = `switch`
                }

                update(cell, `switch`, data)

                return cell
        })
    }
}
