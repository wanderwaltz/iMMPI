import UIKit

final class AnalysisScaleCollectionViewCell: UICollectionViewCell, AnalyserCellProtocol {
    @objc @IBOutlet fileprivate(set) var indexLabel: UILabel?
    @objc @IBOutlet fileprivate(set) var titleLabel: UILabel?

    var scoreLabel: UILabel? {
        return nil
    }

    var titleOffset: CGFloat = 0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    fileprivate func setup() {
        contentView.addBottomBorder(leftMargin: 16.0)
        contentView.addRightBorder()
    }


    @objc @IBOutlet fileprivate var titleLabelLeft: NSLayoutConstraint?
}


extension AnalysisScaleCollectionViewCell {
    override func updateConstraints() {
        titleLabelLeft?.constant = titleOffset + 20.0
        super.updateConstraints()
    }
}
