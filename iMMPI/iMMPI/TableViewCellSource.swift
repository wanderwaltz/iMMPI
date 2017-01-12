import UIKit

/// A class for producing nonoptional `UITableViewCell` instances updated with a certain type of `Data`.
struct TableViewCellSource<Data> {
    /// Initializes a `TableViewCellSource`.
    ///
    /// - Parameters:
    ///    - register: a closure for registering the cell source in a certain `UITableView`.
    ///    - rtv:           table view to regsiter the cell source in.
    ///    - dequeue: a closure for dequeueing a reusable cell from the given table view
    ///               and updating it with the data provided.
    ///    - dtv:           table view to dequeue a cell from.
    ///    - data:          data to update cell with.
    init(register: @escaping (_ rtv: UITableView) -> (),
         dequeue: @escaping (_ dtv: UITableView, _ data: Data?) -> UITableViewCell) {
        _register = register
        _dequeue = dequeue
    }

    fileprivate let _register: (UITableView) -> ()
    fileprivate let _dequeue: (UITableView, Data?) -> UITableViewCell
}


extension TableViewCellSource {
    /// Registers the cell source in the given table view.
    ///
    /// Uses the `register` closure with which the cell source has been initialized.
    ///
    /// - Parameter tableView: table view to register the cell source in.
    func register(in tableView: UITableView) {
        _register(tableView)
    }

    /// Dequeues a cell from the given table view and updates it with optional `Data`.
    ///
    /// Uses the `dequeue` closure with which the cell source has been initialized.
    ///
    /// - Parameters:
    ///    - tableView: table view to dequeue the cell from,
    ///    - data:      data to update the cell with.
    ///
    /// - Returns: the dequeued cell. Since dequeueing the cell is performed using
    ///            the closure provided in the `init` method, the actual logic 
    ///            depends completely on the closure provided. `TableViewCellSource`
    ///            does not know by itself whether the cells are actually being reused,
    ///            or created each time `dequeue` is called.
    func dequeue(from tableView: UITableView, with data: Data?) -> UITableViewCell {
        return _dequeue(tableView, data)
    }
}
