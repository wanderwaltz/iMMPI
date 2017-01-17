import UIKit

protocol EditTestRecordViewControllerDelegate: class {
    func editTestRecordViewController(_ controller: EditTestRecordViewController,
                                      didFinishEditing record: TestRecordProtocol)

    func editTestRecordViewControllerDidCancel(_ controller: EditTestRecordViewController)
}


final class EditTestRecordViewController: UITableViewController, UsingRouting {
    weak var delegate: EditTestRecordViewControllerDelegate?

    var record: TestRecordProtocol? {
        didSet {
            if let record = record {
                selectedGender = record.person.gender
                selectedAgeGroup = record.person.ageGroup
                selectedDate = record.date
                personName = record.personName
            }
        }
    }

    @objc @IBOutlet fileprivate var fullNameTextField: UITextField?
    @objc @IBOutlet fileprivate var genderLabel: UILabel?
    @objc @IBOutlet fileprivate var ageGroupLabel: UILabel?
    @objc @IBOutlet fileprivate var dateLabel: UILabel?

    @objc @IBOutlet fileprivate var genderTableViewCell: UITableViewCell?
    @objc @IBOutlet fileprivate var ageGroupTableViewCell: UITableViewCell?
    @objc @IBOutlet fileprivate var dateTableViewCell: UITableViewCell?

    fileprivate var selectedGender = Gender.male
    fileprivate var selectedAgeGroup = AgeGroup.adult
    fileprivate var selectedDate = Date()
    fileprivate var personName = ""

    fileprivate let dateFormatter: DateFormatter = .medium
}


extension EditTestRecordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fullNameTextField?.becomeFirstResponder()
    }
}


extension EditTestRecordViewController {
    fileprivate func reloadData() {
        ageGroupLabel?.text = selectedAgeGroup.description
        genderLabel?.text = selectedGender.description
        fullNameTextField?.text = personName
        dateLabel?.text = dateFormatter.string(from: selectedDate)
    }


    fileprivate func toggleGender() {
        selectedGender = selectedGender.toggled()
        reloadData()
    }


    fileprivate func toggleAgeGroup() {
        selectedAgeGroup = selectedAgeGroup.toggled()
        reloadData()
    }


    fileprivate func selectDate() {
        guard let dateTableViewCell = dateTableViewCell else {
            return
        }

        let datePicker = DatePickerController()

        datePicker.modalPresentationStyle = .popover
        datePicker.popoverPresentationController?.sourceView = dateTableViewCell
        datePicker.popoverPresentationController?.sourceRect = dateTableViewCell.bounds

        datePicker.date = record?.date ?? Date()
        datePicker.dateDelegate = self

        present(datePicker, animated: true, completion: nil)
    }
}


extension EditTestRecordViewController {
    @objc @IBAction fileprivate func cancelButtonAction(_ sender: Any?) {
        delegate?.editTestRecordViewControllerDidCancel(self)
    }


    @objc @IBAction fileprivate func saveButtonAction(_ sender: Any?) {
        guard let record = record else {
            return
        }

        record.person.name = personName.trimmingCharacters(in: .whitespacesAndNewlines)
        record.person.gender = selectedGender
        record.person.ageGroup = selectedAgeGroup
        record.date = selectedDate

        delegate?.editTestRecordViewController(self, didFinishEditing: record)
    }


    @objc @IBAction fileprivate func textFieldDidChange(_ sender: Any?) {
        personName = fullNameTextField?.text ?? ""
    }
}



// MARK: - DatePickerControllerDateDelegate
extension EditTestRecordViewController: DatePickerControllerDateDelegate {
    func datePickerController(_ datePickerController: DatePickerController, didSelect date: Date) {
        selectedDate = date
        reloadData()
    }
}



// MARK: - UITableViewDelegate
extension EditTestRecordViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        let fallbackCell = UITableViewCell()

        switch cell {
        case (genderTableViewCell ?? fallbackCell):
            toggleGender()

        case (ageGroupTableViewCell ?? fallbackCell):
            toggleAgeGroup()

        case (dateTableViewCell ?? fallbackCell):
            selectDate()

        default:
            break
        }
    }
}
