import UIKit
import Utils

extension ReusableViewSource where Container: UITableView, View: UITableViewCell {
    static func `switch`(
        identifier: String = "com.immpi.cells.switch",
        update: @escaping (_ cell: View, _ `switch`: UISwitch, _ data: Data?) -> ())
        -> ReusableViewSource<Container, View, Data> {
            return ReusableViewSource(
                register: Constant.value(()),
                dequeue: { container, indexPath, data in
                    let cell = container.dequeueReusableCell(withIdentifier: identifier) as? View
                        ?? View(style: .default, reuseIdentifier: identifier)

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
