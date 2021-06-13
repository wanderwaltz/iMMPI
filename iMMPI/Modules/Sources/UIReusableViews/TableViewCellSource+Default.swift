import UIKit
import Utils

extension ReusableViewSource where Container: UITableView, View: UITableViewCell {
    /// Initializes a `ReusableViewSource` for returning a reusable cell with a given style and reuse identifier.
    ///
    /// Cells are dequeued from the table view or created on the fly if dequeueing is not possible.
    ///
    /// - Parameters:
    ///    - style: style of cells to create,
    ///    - identifier: reuse identifier of cells to create,
    ///    - update: closure for updating the created cells with the provided data.
    ///    - cell: cell to update with the provided data.
    ///    - data: data to update thecell with.
    public init(
        style: UITableViewCell.CellStyle,
        identifier: String,
        update: @escaping (_ cell: View, _ data: Data?) -> ()
    ) {
        self.init(
            register: Constant.value(()),
            dequeue: { container, indexPath, data in
                let cell = container.dequeueReusableCell(withIdentifier: identifier) as? View
                    ?? View(style: style, reuseIdentifier: identifier)
                update(cell, data)
                return cell
            }
        )
    }
}
