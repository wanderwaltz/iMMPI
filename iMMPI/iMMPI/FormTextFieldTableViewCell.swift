import UIKit

final class FormTextFieldTableViewCell: FormTableViewCell {
    private(set) var textField: UITextField!

    override init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    private func setup() {
        textField = UITextField()
        textField.frame = rightContentView.bounds
        textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textField.font = .systemFont(ofSize: 18.0)
        textField.textColor = .black

        rightContentView.addSubview(textField)
    }
}
