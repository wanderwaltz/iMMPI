import UIKit

extension UITableView: ReusableCellDequeueing, CellClassRegistering, CellNibRegistering {
    typealias ReuseIdentifier = String
    typealias Cell = UITableViewCell
}
