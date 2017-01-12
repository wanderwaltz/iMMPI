import UIKit

final class AnalyserTableViewCell: UITableViewCell {
    @objc @IBOutlet fileprivate(set) var groupNameLabel: UILabel?
    @objc @IBOutlet fileprivate(set) var scoreLabel: UILabel?
    @objc @IBOutlet fileprivate(set) var indexLabel: UILabel?

    var groupNameOffset: CGFloat = 0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    @objc @IBOutlet fileprivate var groupNameLabelLeft: NSLayoutConstraint?
}


extension AnalyserTableViewCell {
    override func updateConstraints() {
        groupNameLabelLeft?.constant = groupNameOffset + 20.0
        super.updateConstraints()
    }
}
