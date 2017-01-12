import Foundation

extension TableViewCellSource {
    static func nib<Cell: UITableViewCell>(
        _ nib: @escaping @autoclosure () -> UINib = UINib(nibName: String(describing: Cell.self),
                                                          bundle: Bundle(for: Cell.self)),
        identifier: String = String(describing: Cell.self),
        update: @escaping (Cell, Data?) -> ()) -> TableViewCellSource {
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
