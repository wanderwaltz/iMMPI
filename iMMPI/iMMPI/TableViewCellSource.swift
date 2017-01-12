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
