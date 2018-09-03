import UIKit

final class FormLabelTableViewCell: FormTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()

        detailTextLabel?.font = .systemFont(ofSize: 18.0)
        detailTextLabel?.textColor = .black

        detailTextLabel?.frame = rightContentView.frame
    }
}
