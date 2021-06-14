import UIKit

public protocol DatePickerControllerDateDelegate: AnyObject {
    func datePickerController(_ datePickerController: DatePickerController, didSelect date: Date)
}

public class DatePickerController : UIViewController {
    public weak var dateDelegate: DatePickerControllerDateDelegate?

    public var date: Date {
        set { datePicker.date = newValue }
        get { datePicker.date }
    }

    public var datePickerMode: UIDatePicker.Mode {
        set { datePicker.datePickerMode = newValue }
        get { datePicker.datePickerMode }
    }

    private let datePicker = UIDatePicker()

    public override func viewDidLoad() {
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
