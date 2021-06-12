import UIKit

typealias TableViewCellSource<Data> = ReusableViewSource<UITableView, UITableViewCell, Data>
typealias CollectionViewCellSource<Data> = ReusableViewSource<UICollectionView, UICollectionViewCell, Data>

protocol ReusableCellDequeueing {
    associatedtype ReuseIdentifier
    associatedtype Cell: UIView

    func dequeueReusableCell(withIdentifier identifier: ReuseIdentifier, for indexPath: IndexPath) -> Cell
}


protocol CellClassRegistering {
    associatedtype ReuseIdentifier
    associatedtype Cell: UIView

    func register(_ cellClass: AnyClass?, forCellReuseIdentifier reuseIdentifier: ReuseIdentifier)
}


protocol CellNibRegistering {
    associatedtype ReuseIdentifier
    associatedtype Cell: UIView

    func register(_ nib: UINib?, forCellReuseIdentifier reuseIdentifier: ReuseIdentifier)
}



extension UITableView: ReusableCellDequeueing, CellClassRegistering, CellNibRegistering {
    typealias ReuseIdentifier = String
    typealias Cell = UITableViewCell
}


extension UICollectionView: ReusableCellDequeueing, CellClassRegistering, CellNibRegistering {
    typealias ReuseIdentifier = String
    typealias Cell = UICollectionViewCell

    @nonobjc func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    @nonobjc func register(_ cellClass: AnyClass?, forCellReuseIdentifier reuseIdentifier: String) {
        register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
    }

    @nonobjc func register(_ nib: UINib?, forCellReuseIdentifier reuseIdentifier: String) {
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
