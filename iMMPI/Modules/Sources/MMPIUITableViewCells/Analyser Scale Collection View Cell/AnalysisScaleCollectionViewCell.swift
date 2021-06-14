import UIKit

public final class AnalysisScaleCollectionViewCell: UICollectionViewCell, AnalyserCellProtocol {
    @objc @IBOutlet public private(set) var indexLabel: UILabel?
    @objc @IBOutlet public private(set) var titleLabel: UILabel?

    public var scoreLabel: UILabel? {
        return nil
    }

    public var titleOffset: CGFloat = 0 {
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
    public override func updateConstraints() {
        titleLabelLeft?.constant = titleOffset + 20.0
        super.updateConstraints()
    }
}
