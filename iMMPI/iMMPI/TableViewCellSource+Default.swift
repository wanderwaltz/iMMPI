import Foundation

extension TableViewCellSource {
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
