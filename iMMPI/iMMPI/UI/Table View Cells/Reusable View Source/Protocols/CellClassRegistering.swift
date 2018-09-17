import UIKit

protocol CellClassRegistering {
    associatedtype ReuseIdentifier
    associatedtype Cell: UIView

    func register(_ cellClass: AnyClass?, forCellReuseIdentifier reuseIdentifier: ReuseIdentifier)
}
