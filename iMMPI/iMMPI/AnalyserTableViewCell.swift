import UIKit

final class AnalyserTableViewCell: UITableViewCell, AnalyserCellProtocol {
    @objc @IBOutlet fileprivate(set) var titleLabel: UILabel?
    @objc @IBOutlet fileprivate(set) var scoreLabel: UILabel?
    @objc @IBOutlet fileprivate(set) var indexLabel: UILabel?

    var titleOffset: CGFloat = 0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    @objc @IBOutlet fileprivate var titleLabelLeft: NSLayoutConstraint?
}


extension AnalyserTableViewCell {
    override func updateConstraints() {
        titleLabelLeft?.constant = titleOffset + 20.0
        super.updateConstraints()
    }
}
