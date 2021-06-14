import UIKit

public final class AnalysisScoreCollectionViewCell: UICollectionViewCell, AnalyserCellProtocol {
    @objc @IBOutlet public private(set) var scoreLabel: UILabel?

    public var indexLabel: UILabel? {
        return nil
    }

    public var titleLabel: UILabel? {
        return nil
    }

    public var titleOffset: CGFloat = 0

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
