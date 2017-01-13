import Foundation

extension TableViewCellSource {
    /// Initializes a `TableViewCellSource` for returning a reusable cell with a given style and reuse identifier.
    ///
    /// Cells are dequeued from the table view or created on the fly if dequeueing is not possible. Registration
    /// of this cell source in the table view prior its usage is not required.
    ///
    /// - Parameters:
    ///    - style: style of cells to create,
    ///    - identifier: reuse identifier of cells to create,
    ///    - update: closure for updating the created cells with the provided data.
    ///    - cell: cell to update with the provided data.
    ///    - data: data to update thecell with.
    init(style: UITableViewCellStyle,
         identifier: String,
         update: @escaping (_ cell: UITableViewCell, _ data: Data?) -> ()) {
        self.init(
            register: Constant.void(),
            dequeue: { tableView, data in
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
                    ?? UITableViewCell(style: style, reuseIdentifier: identifier)
                update(cell, data)
                return cell
        })
    }
}
