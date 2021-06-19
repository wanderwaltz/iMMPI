import UIKit

final class ComputationTitleCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!

    func update(title: String) {
        titleLabel?.text = title
    }
}
