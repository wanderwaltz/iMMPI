import UIKit

final class SectionHeader: UICollectionReusableView {
    @IBOutlet private var titleLabel: UILabel!

    func setText(_ text: String) {
        titleLabel?.text = text
    }
}
