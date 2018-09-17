import UIKit

extension ReusableViewSource where
    Container: ReusableCellDequeueing,
    Container: CellClassRegistering,
    Container.ReuseIdentifier == String {
    /// Initializes a `ReusableViewCellSource` for loading cells of a given class.
    ///
    /// Registration in the table view is required prior using this cell source.
    ///
    /// - Note: As per Swift 3.0, it is impossible to specify generic parameters of a generic function explicitly.
    ///         These parameters are always implied from the context. In case of this function, `Cell` generic parameter
    ///         is implied based on the `update` function provided.
    ///
    /// - Parameters:
    ///    - class: class of the cells to dequeue,
    ///    - identifier: reuse identifier of the cells to load,
    ///    - update: closure for updating the cell with the provided data.
    ///    - cell: cell to update with the provided data.
    ///    - data: data to update thecell with.
    static func withClass<Cell: UIView>(_ cellClass: Cell.Type,
        identifier: String = String(describing: Cell.self),
        update: @escaping (_ cell: Cell, _ data: Data?) -> ()) -> ReusableViewSource<Container, View, Data> {
        return ReusableViewSource(
            register: { $0.register(cellClass, forCellReuseIdentifier: identifier) },
            dequeue: { container, indexPath, data in
                let cell = container.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
                update(cell, data)
                return cell as! View
        })
    }
}
