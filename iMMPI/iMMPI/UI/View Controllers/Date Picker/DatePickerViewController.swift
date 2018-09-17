import UIKit

protocol DatePickerViewControllerDelegate: class {
    func datePickerViewController(_ datePickerViewController: DatePickerViewController, didSelect date: Date)
}

class DatePickerViewController : UIViewController {
    weak var delegate: DatePickerViewControllerDelegate?

    var date: Date {
        set {
            datePicker.date = newValue
        }
        get {
            return datePicker.date
        }
    }

    var datePickerMode: UIDatePickerMode {
        set {
            datePicker.datePickerMode = newValue
        }
        get {
            return datePicker.datePickerMode
        }
    }

    fileprivate let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.datePickerMode = .date

        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        view.addSubview(datePicker)
        preferredContentSize = datePicker.bounds.size
    }

    @objc func datePickerValueChanged(_ datePicker: Any) {
        delegate?.datePickerViewController(self, didSelect: date)
    }
}
