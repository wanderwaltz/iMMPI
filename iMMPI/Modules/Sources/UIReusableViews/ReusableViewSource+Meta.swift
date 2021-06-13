import UIKit

public typealias TableViewCellSource<Data> = ReusableViewSource<UITableView, UITableViewCell, Data>
public typealias CollectionViewCellSource<Data> = ReusableViewSource<UICollectionView, UICollectionViewCell, Data>

public protocol ReusableCellDequeueing {
    associatedtype ReuseIdentifier
    associatedtype Cell: UIView

    func dequeueReusableCell(withIdentifier identifier: ReuseIdentifier, for indexPath: IndexPath) -> Cell
}


public protocol CellClassRegistering {
    associatedtype ReuseIdentifier
    associatedtype Cell: UIView

    func register(_ cellClass: AnyClass?, forCellReuseIdentifier reuseIdentifier: ReuseIdentifier)
}


public protocol CellNibRegistering {
    associatedtype ReuseIdentifier
    associatedtype Cell: UIView

    func register(_ nib: UINib?, forCellReuseIdentifier reuseIdentifier: ReuseIdentifier)
}



extension UITableView: ReusableCellDequeueing, CellClassRegistering, CellNibRegistering {
    public typealias ReuseIdentifier = String
    public typealias Cell = UITableViewCell
}


extension UICollectionView: ReusableCellDequeueing, CellClassRegistering, CellNibRegistering {
    public typealias ReuseIdentifier = String
    public typealias Cell = UICollectionViewCell

    @nonobjc public func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    @nonobjc public func register(_ cellClass: AnyClass?, forCellReuseIdentifier reuseIdentifier: String) {
        register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
    }

    @nonobjc public func register(_ nib: UINib?, forCellReuseIdentifier reuseIdentifier: String) {
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
