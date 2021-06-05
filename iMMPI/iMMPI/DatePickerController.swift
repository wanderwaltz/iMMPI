import UIKit

protocol DatePickerControllerDateDelegate: class {
    func datePickerController(_ datePickerController: DatePickerController, didSelect date: Date)
}

class DatePickerController : UIViewController {

    weak var dateDelegate: DatePickerControllerDateDelegate?

    var date: Date {
        set {
            datePicker.date = newValue
        }
        get {
            return datePicker.date
        }
    }

    var datePickerMode: UIDatePicker.Mode {
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
        dateDelegate?.datePickerController(self, didSelect: date)
    }
}
