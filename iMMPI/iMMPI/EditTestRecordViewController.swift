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


    override init(style: UITableViewStyle) {
        super.init(style: style)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    private func setup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonAction(_:))
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonAction(_:))
        )

        nameCell.textLabel?.text = Strings.formPersonName
        nameCell.textField.placeholder = Strings.formPersonNamePlaceholder
        nameCell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: [.editingChanged])

        genderCell.textLabel?.text = Strings.formGender
        ageGroupCell.textLabel?.text = Strings.formAgeGroup
        dateCell.textLabel?.text = Strings.formDate

        let layout = FormTableViewCell.Layout(contentMargin: 20.0, titleMargin: 20.0, titleWidth: { [weak self] in
            guard let this = self else {
                return 0.0
            }

            return this.rows.map({ $0.textLabel?.intrinsicContentSize.width ?? 0.0 }).max() ?? 0.0
        })

        nameCell.layout = layout
        genderCell.layout = layout
        ageGroupCell.layout = layout
        dateCell.layout = layout
    }


    fileprivate let nameCell = FormTextFieldTableViewCell(reuseIdentifier: "com.immpi.cells.form.textField")
    fileprivate let genderCell = FormLabelTableViewCell(reuseIdentifier: "com.immpi.cells.form.label")
    fileprivate let ageGroupCell = FormLabelTableViewCell(reuseIdentifier: "com.immpi.cells.form.label")
    fileprivate let dateCell = FormLabelTableViewCell(reuseIdentifier: "com.immpi.cells.form.label")

    fileprivate var rows: [UITableViewCell] {
        return [
            nameCell,
            genderCell,
            ageGroupCell,
            dateCell
        ]
    }

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
        nameCell.textField.becomeFirstResponder()
    }
}


extension EditTestRecordViewController {
    fileprivate func reloadData() {
        ageGroupCell.detailTextLabel?.text = selectedAgeGroup.description
        genderCell.detailTextLabel?.text = selectedGender.description
        nameCell.textField.text = personName
        dateCell.detailTextLabel?.text = dateFormatter.string(from: selectedDate)

        nameCell.setNeedsLayout()
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
        let datePicker = DatePickerController()

        datePicker.modalPresentationStyle = .popover
        datePicker.popoverPresentationController?.sourceView = dateCell
        datePicker.popoverPresentationController?.sourceRect = dateCell.bounds

        datePicker.date = record?.date ?? Date()
        datePicker.dateDelegate = self

        present(datePicker, animated: true, completion: nil)
    }
}


extension EditTestRecordViewController {
    @objc fileprivate func cancelButtonAction(_ sender: Any?) {
        delegate?.editTestRecordViewControllerDidCancel(self)
    }


    @objc fileprivate func saveButtonAction(_ sender: Any?) {
        guard let record = record else {
            return
        }

        record.person.name = personName.trimmingCharacters(in: .whitespacesAndNewlines)
        record.person.gender = selectedGender
        record.person.ageGroup = selectedAgeGroup
        record.date = selectedDate

        delegate?.editTestRecordViewController(self, didFinishEditing: record)
    }


    @objc fileprivate func textFieldDidChange(_ sender: Any?) {
        personName = nameCell.textField.text ?? ""
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

        switch cell {
        case genderCell: toggleGender()
        case ageGroupCell: toggleAgeGroup()
        case dateCell: selectDate()

        default:
            break
        }
    }
}


// MARK: - UITableViewDataSource
extension EditTestRecordViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rows[indexPath.row]
    }
}
