import UIKit

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
