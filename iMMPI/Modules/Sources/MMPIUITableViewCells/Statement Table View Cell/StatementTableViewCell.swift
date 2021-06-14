import UIKit

public final class StatementTableViewCell: UITableViewCell {
    /// Label which is used to display the ID of the statement
    @objc @IBOutlet fileprivate(set) var identifierLabel: UILabel?

    /// Label which is used to display the text of the statement
    @objc @IBOutlet fileprivate(set) var statementTextLabel: UILabel?

    /// Label which is used to display the user provided answer (positive/negative) to the statement in textual form
    @objc @IBOutlet fileprivate(set) var answerLabel: UILabel?

    /// Segmented control which is used to display the user privided answer 
    /// (positive/negative) to the statement (usually 0 is negative, 1 is positive)
    @objc @IBOutlet fileprivate(set) var segmentedControl: UISegmentedControl?

    public var isCurrent: Bool {
        get { _isCurrent }
        set {
            _isCurrent = newValue
            setNeedsLayout()
        }
    }

    private var _isCurrent = false

    public override func layoutSubviews() {
        super.layoutSubviews()
        identifierLabel?.isHighlighted = _isCurrent
        statementTextLabel?.isHighlighted = _isCurrent
        answerLabel?.isHighlighted = _isCurrent
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        _isCurrent = false
    }
}
