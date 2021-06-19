import UIKit

final class ComputationBodyCell: UICollectionViewCell {
    @IBOutlet private var textLabel: UILabel!

    func update(text: String) {
        textLabel?.text = text
    }
}
