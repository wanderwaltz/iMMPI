import UIKit

protocol DatePickerViewControllerDelegate: class {
    func datePickerViewController(_ datePickerViewController: DatePickerViewController, didSelect date: Date)
}
