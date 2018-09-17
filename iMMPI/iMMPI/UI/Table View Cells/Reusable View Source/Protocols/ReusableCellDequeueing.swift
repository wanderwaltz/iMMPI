import UIKit

protocol ReusableCellDequeueing {
    associatedtype ReuseIdentifier
    associatedtype Cell: UIView

    func dequeueReusableCell(withIdentifier identifier: ReuseIdentifier, for indexPath: IndexPath) -> Cell
}
