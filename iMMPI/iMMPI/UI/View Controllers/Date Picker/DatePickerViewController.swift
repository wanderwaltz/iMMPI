import UIKit

final class DatePickerViewController : UIViewController {
    // MARK: properties
    weak var delegate: DatePickerViewControllerDelegate?

    var date: Date {
        set {
            datePicker.date = newValue
        }
        get {
            return datePicker.date
        }
    }

    // MARK: initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        finalizeInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    private func finalizeInit() {
        setupDatePicker()

        preferredContentSize = datePicker.bounds.size
    }

    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    // MARK: private properties
    private let datePicker = UIDatePicker()
}


// MARK: view lifecycle
extension DatePickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addDatePickerSubview()
    }

    private func addDatePickerSubview() {
        datePicker.translatesAutoresizingMaskIntoConstraints = true
        datePicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.bounds = datePicker.bounds
        view.addSubview(datePicker)
    }
}


// MARK: private: actions
extension DatePickerViewController {
    @objc private func datePickerValueChanged(_ datePicker: Any) {
        delegate?.datePickerViewController(self, didSelect: date)
    }
}
