import UIKit

final class RecordsListViewController: StoryboardManagedTableViewController {
    var storage: TestRecordStorage?
    var model: MutableTableViewModel?

    fileprivate let dateFormatter: DateFormatter = .medium
    fileprivate let nameFormatter: Formatter = AbbreviatedNameFormatter()
}



extension RecordsListViewController {
    fileprivate func delete(_ record: TestRecordProtocol, at indexPath: IndexPath) -> Bool {
        storage?.remove(record)
        return model?.remove(record) ?? false
    }
}



// MARK: - SegueSourceEditAnswers
extension RecordsListViewController: SegueSourceEditAnswers {
    func testRecordToEditAnswers(with sender: Any?) -> TestRecordProtocol? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }

        return model?.object(at: indexPath) as? TestRecordProtocol
    }


    func storageToEditAnswers(with sender: Any?) -> TestRecordStorage? {
        return storage
    }
}



// MARK: - SegueSourceAnalyzeRecord
extension RecordsListViewController: SegueSourceAnalyzeRecord {
    func recordForAnalysis(with sender: Any?) -> TestRecordProtocol? {
        // Essentialy we can open the analyzer screen only in the
        // same circumstances as if we were editing answers for
        // a certain record - when the corresponding records group
        // contains a single record. So we return the value of an
        // existing method to avoid duplication of code
        return testRecordToEditAnswers(with: sender)
    }


    func storageForAnalysis(with sender: Any?) -> TestRecordStorage? {
        return storage
    }
}



// MARK: - SegueSourceEditRecord
extension RecordsListViewController: SegueSourceEditRecord {
    func titleForEditing(_ record: TestRecordProtocol, with sender: Any?) -> String {
        if sender is UITableViewCell {
            return Strings.editRecord
        }
        else {
            return Strings.newRecord
        }
    }


    public func testRecordToEdit(with sender: Any?) -> TestRecordProtocol? {
        if sender is UITableViewCell {
            return testRecordToEditAnswers(with: sender)
        }
        else {
            return TestRecord()
        }
    }

    public func delegateForEditingTestRecord(with sender: Any?) -> EditTestRecordViewControllerDelegate {
        return self
    }
}



// MARK: - SegueDestinationListRecords
extension RecordsListViewController: SegueDestinationListRecords {
    func setModelForListRecords(_ model: MutableTableViewModel) {
        self.model = model
    }


    func setStorageForListRecords(_ storage: TestRecordStorage) {
        self.storage = storage
    }


    func setTitleForListRecords(_ title: String) {
        self.title = title
    }


    func setSelectedTestRecord(_ record: TestRecordProtocol?) {
        guard let record = record, let indexPath = model?.indexPath(for: record) else {
            return
        }

        // For some reason row cannot be selected without dispatch_async here
        // even though 'Selection: clear on appearance' is set to NO in the storyboard
        DispatchQueue.main.async {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
}



// MARK: - EditTestRecordViewControllerDelegate
extension RecordsListViewController: EditTestRecordViewControllerDelegate {
    func editTestRecordViewController(_ controller: EditTestRecordViewController,
                                      didFinishEditing record: TestRecordProtocol?) {
        dismiss(animated: true, completion: nil)

        if let record = record {
            guard let storage = storage else {
                preconditionFailure()
            }

            if storage.contains(record) {
                model?.update(record)
                storage.update(record)
            }
            else {
                model?.addNewObject(record)
                storage.add(record)
            }

            tableView.reloadData()
            performSegue(withIdentifier: kSegueIDBlankDetail, sender: self)
        }
    }
}



// MARK: - UITableViewDataSource
extension RecordsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Int(model?.numberOfSections() ?? 0)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(model?.numberOfRows(inSection: UInt(section)) ?? 0)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRecordCellIdentifier) ??
            UITableViewCell(style: .default, reuseIdentifier: kRecordCellIdentifier)

        if let record = model?.object(at: indexPath) as? TestRecordProtocol {
            cell.textLabel?.text = nameFormatter.string(for: record.personName)
            cell.detailTextLabel?.text = dateFormatter.string(from: record.date)
        }

        return cell
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard let record = model?.object(at: indexPath) as? TestRecordProtocol else {
            return
        }

        if delete(record, at: indexPath) {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}



// MARK: - UITableViewDelegate
extension RecordsListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let record = model?.object(at: indexPath) as? TestRecordProtocol else {
            return
        }

        let sender = tableView.cellForRow(at: indexPath)

        // If already answered the test, go straight to analyzer
        if record.testAnswers.allStatementsAnswered {
            performSegue(withIdentifier: kSegueIDAnalyzer, sender: sender)
        }
        // Else we have to input all answers first
        else {
            performSegue(withIdentifier: kSegueIDAnswersInput, sender: sender)
        }
    }


    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }


    override func tableView(_ tableView: UITableView,
                            titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return Strings.delete
    }
}


fileprivate let kRecordCellIdentifier = "com.immpi.cells.record"
