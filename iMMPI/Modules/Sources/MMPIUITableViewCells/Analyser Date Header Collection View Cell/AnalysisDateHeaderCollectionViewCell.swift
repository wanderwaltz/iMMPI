import UIKit

public final class AnalysisDateHeaderCollectionViewCell: UICollectionViewCell {
    @objc @IBOutlet public private(set) var titleLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        contentView.addBottomBorder()
        contentView.addRightBorder()
    }
}
