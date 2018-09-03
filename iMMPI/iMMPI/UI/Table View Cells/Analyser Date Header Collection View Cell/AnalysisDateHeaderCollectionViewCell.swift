import UIKit

final class AnalysisDateHeaderCollectionViewCell: UICollectionViewCell {
    @objc @IBOutlet fileprivate(set) var titleLabel: UILabel?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    fileprivate func setup() {
        contentView.addBottomBorder()
        contentView.addRightBorder()
    }
}
