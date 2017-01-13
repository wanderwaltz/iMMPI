import Foundation

extension TableViewCellSource {
    /// Initializes a `TableViewCellSource` for loading cells of a given class from the `UINib` provided.
    ///
    /// Registration in the table view is required prior using this cell source.
    ///
    /// - Note: As per Swift 3.0, it is impossible to specify generic parameters of a generic function explicitly.
    ///         These parameters are always implied from the context. In case of this function, `Cell` generic parameter
    ///         is implied based on the `update` function provided.
    ///
    /// - Parameters:
    ///    - nib: `UINib` to load cells from. Defaults to a nib named the same as the `Cell` class located
    ///           in bundle for the `Cell` class,
    ///    - identifier: reuse identifier of the cells to load. Must match the reuse identifier of the cell
    ///                  inside the nib, otherwise an Objective-C exception is thrown when trying to dequeue,
    ///    - update: closure for updating the cell with the provided data.
    ///    - cell: cell to update with the provided data.
    ///    - data: data to update thecell with.
    static func nib<Cell: UITableViewCell>(
        _ nib: @escaping @autoclosure () -> UINib = UINib(nibName: String(describing: Cell.self),
                                                          bundle: Bundle(for: Cell.self)),
        identifier: String = String(describing: Cell.self),
        update: @escaping (_ cell: Cell, _ data: Data?) -> ()) -> TableViewCellSource {
        return TableViewCellSource(
            register: { tableView in
                tableView.register(nib(), forCellReuseIdentifier: identifier)
        },
            dequeue: { tableView, data in
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! Cell
                update(cell, data)
                return cell
        })
    }
}