import UIKit

final class AnalysisScoreCollectionViewCell: UICollectionViewCell, AnalyserCellProtocol {
    @objc @IBOutlet fileprivate(set) var scoreLabel: UILabel?

    var indexLabel: UILabel? {
        return nil
    }

    var titleLabel: UILabel? {
        return nil
    }

    var titleOffset: CGFloat = 0


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
