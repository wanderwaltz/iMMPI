import UIKit
import DataModel

final class StatementCell: UICollectionViewCell {
    enum Style {
        case positive
        case negative

    }

    @IBOutlet private var titleLabel: UILabel!

    func update(statement: Statement.Identifier, style: Style, matching: Bool) {
        titleLabel?.text = String(describing: statement)

        if matching {
            contentView.backgroundColor = style == .positive
                ? UIColor.systemBlue.withAlphaComponent(0.5)
                : UIColor.systemPink.withAlphaComponent(0.5)
        }
        else {
            contentView.backgroundColor = .systemBackground
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.layer.borderWidth = 1.0 / UIScreen.main.scale
        titleLabel?.layer.borderColor = UIColor.separator.cgColor
    }
}
