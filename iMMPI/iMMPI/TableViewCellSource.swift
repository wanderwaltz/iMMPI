import UIKit

struct TableViewCellSource<Data> {
    init(register: @escaping (UITableView) -> (), dequeue: @escaping (UITableView, Data?) -> UITableViewCell) {
        _register = register
        _dequeue = dequeue
    }

    fileprivate let _register: (UITableView) -> ()
    fileprivate let _dequeue: (UITableView, Data?) -> UITableViewCell
}


extension TableViewCellSource {
    func register(in tableView: UITableView) {
        _register(tableView)
    }

    func dequeue(from tableView: UITableView, with data: Data?) -> UITableViewCell {
        return _dequeue(tableView, data)
    }
}


extension TableViewCellSource {
    static func preregistered<Cell: UITableViewCell>(identifier: String, update: @escaping (Cell, Data?) -> ())
        -> TableViewCellSource {
            return TableViewCellSource(register: Constant.void(), dequeue: { tableView, data in
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! Cell
                update(cell, data)
                return cell
            })
    }


    static func nib<Cell: UITableViewCell>(
        nib: UINib = UINib(nibName: String(describing: Cell.self), bundle: Bundle(for: Cell.self)),
        identifier: String = String(describing: Cell.self),
        update: @escaping (Cell, Data?) -> ()) -> TableViewCellSource {
        return TableViewCellSource(
            register: { tableView in
                tableView.register(nib, forCellReuseIdentifier: identifier)
        },
            dequeue: { tableView, data in
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! Cell
                update(cell, data)
                return cell
        })
    }


    init<Cell: UITableViewCell>(identifier: String = String(describing: Cell.self),
         update: @escaping (Cell, Data?) -> ()) {
        self.init(
            register: { tableView in
                tableView.register(Cell.self, forCellReuseIdentifier: identifier)
        },
            dequeue: { tableView, data in
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! Cell
                update(cell, data)
                return cell
        })
    }


    init(style: UITableViewCellStyle, identifier: String, update: @escaping (UITableViewCell, Data?) -> ()) {
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
