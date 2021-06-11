import UIKit

final class FormLabelTableViewCell: FormTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()

        detailTextLabel?.font = .systemFont(ofSize: 18.0)
        
        if #available(iOS 13.0, *) {
            detailTextLabel?.textColor = .label
        } else {
            detailTextLabel?.textColor = .darkText
        }

        detailTextLabel?.frame = rightContentView.frame
    }
}
