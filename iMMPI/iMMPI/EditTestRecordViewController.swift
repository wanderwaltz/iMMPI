import UIKit

@objc protocol EditTestRecordViewControllerDelegate {
    // TODO: add a dedicated cancellation method and make test record nonoptional
    @objc(editTestRecordViewController:didFinishEditingRecord:)
    func editTestRecordViewController(_ controller: EditTestRecordViewController,
                                      didFinishEditing record: TestRecordProtocol?)
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
    fileprivate let datePickerPopover = FRBDatePickerPopover()
}


extension EditTestRecordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()

        datePickerPopover.title = Strings.selectDate;
        datePickerPopover.dateDelegate = self;
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

        datePickerPopover.dismiss(animated: false)
        datePickerPopover.present(from: dateTableViewCell.bounds, in: dateTableViewCell,
                                  permittedArrowDirections: .any, animated: true)
    }
}


extension EditTestRecordViewController {
    @objc @IBAction fileprivate func cancelButtonAction(_ sender: Any?) {
        delegate?.editTestRecordViewController(self, didFinishEditing: nil)
    }


    @objc @IBAction fileprivate func saveButtonAction(_ sender: Any?) {
        record?.person.name = personName.trimmingCharacters(in: .whitespacesAndNewlines)
        record?.person.gender = selectedGender
        record?.person.ageGroup = selectedAgeGroup
        record?.date = selectedDate

        delegate?.editTestRecordViewController(self, didFinishEditing: record)
    }


    @objc @IBAction fileprivate func textFieldDidChange(_ sender: Any?) {
        personName = fullNameTextField?.text ?? ""
    }
}



// MARK: - FRBDatePickerPopoverDateDelegate
extension EditTestRecordViewController: FRBDatePickerPopoverDateDelegate {
    func frbDatePickerPopover(_ popover: FRBDatePickerPopover, didSelect date: Date) {
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
