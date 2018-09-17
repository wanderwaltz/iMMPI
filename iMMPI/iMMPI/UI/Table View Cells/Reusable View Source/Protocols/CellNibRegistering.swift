import UIKit

protocol CellNibRegistering {
    associatedtype ReuseIdentifier
    associatedtype Cell: UIView

    func register(_ nib: UINib?, forCellReuseIdentifier reuseIdentifier: ReuseIdentifier)
}
