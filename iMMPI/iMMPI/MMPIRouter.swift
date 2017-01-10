import UIKit

final class MMPIRouter {
    enum Error: Swift.Error {
        case failedInstantiatingViewController
    }

    let storyboard: UIStoryboard
    let storage: TestRecordStorage
    let trashStorage: TestRecordStorage

    init(storyboard: UIStoryboard, storage: TestRecordStorage, trashStorage: TestRecordStorage) {
        self.storyboard = storyboard
        self.storage = storage
        self.trashStorage = trashStorage
        self.editingDelegate = EditingDelegate(storage: storage)
    }

    fileprivate let editingDelegate: EditingDelegate
}


extension MMPIRouter: Router {
    func displayAllRecords(sender: UIViewController) throws {
        try displayRecordsList(with: storage, sender: sender)
    }


    func displayTrash(sender: UIViewController) throws {
        try displayRecordsList(with: trashStorage, sender: sender)
    }


    func displayDetails(for group: TestRecordsGroup, sender: UIViewController) throws {
        if group.group.isEmpty {
            try displayDetails(for: group.record, sender: sender)
        }
        else {
            try expand(group, sender: sender)
        }
    }


    func edit(_ record: TestRecordProtocol, sender: UIViewController) throws {
        guard let controller = makeEditRecordViewController() else {
            throw Error.failedInstantiatingViewController
        }

        controller.setTestRecordToEdit(record)
        controller.setTitleForEditingTestRecord(Strings.editRecord)
        controller.setDelegateForEditingTestRecord(editingDelegate)

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .formSheet
        sender.present(navigationController, animated: true, completion: nil)
    }


    func displayAnswersInput(for record: TestRecordProtocol, sender: UIViewController) throws {
        guard let controller = makeAnswersInputViewController() else {
            throw Error.failedInstantiatingViewController
        }

        controller.setRecordToEditAnswers(record)
        controller.setStorageToEditAnswers(storage)

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }
}


extension MMPIRouter {
    func displayRecordsList(with storage: TestRecordStorage, sender: UIViewController) throws {
        guard let controller = makeRecordsListViewController() else {
            throw Error.failedInstantiatingViewController
        }

        controller.router = self
        controller.viewModel = storage.makeViewModel()
        controller.title = Strings.trash

        sender.show(controller, sender: nil)
    }

    fileprivate func expand(_ group: TestRecordsGroup, sender: UIViewController) throws {
        guard let controller = makeRecordsListViewController() else {
            throw Error.failedInstantiatingViewController
        }

        controller.title = group.personName
        controller.style = .nested(basedOn: group.record)
        controller.grouping = .flat
        controller.router = self

        controller.viewModel = storage.makeViewModel(includeRecord: { record in
            if record.personName.isEqual(group.personName) {
                return true
            }

            for subgroup in group.group.allItems {
                if record.personName.isEqual(subgroup.personName) {
                    return true
                }
            }

            return false
        })

        sender.show(controller, sender: group)
    }


    fileprivate func displayDetails(for record: TestRecordProtocol, sender: UIViewController) throws {
        if record.testAnswers.allStatementsAnswered {
            try displayAnalysis(for: record, sender: sender)
        }
        else {
            try displayAnswersInput(for: record, sender: sender)
        }
    }


    fileprivate func displayAnalysis(for record: TestRecordProtocol, sender: UIViewController) throws {
        guard let controller = makeAnalysisViewController() else {
            throw Error.failedInstantiatingViewController
        }

        controller.setRecordForAnalysis(record)
        controller.setStorageForAnalysis(storage)

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }
}


extension MMPIRouter {
    fileprivate func makeRecordsListViewController() -> RecordsListViewController? {
        return storyboard.instantiateViewController(
            withIdentifier: ViewController.testRecords
            ) as? RecordsListViewController
    }


    fileprivate func makeEditRecordViewController() -> EditTestRecordViewController? {
        return storyboard.instantiateViewController(
            withIdentifier: ViewController.editRecord
            ) as? EditTestRecordViewController
    }


    fileprivate func makeAnalysisViewController() -> AnalysisViewController? {
        return storyboard.instantiateViewController(
            withIdentifier: ViewController.analysis
            ) as? AnalysisViewController
    }


    fileprivate func makeAnswersInputViewController() -> TestAnswersInputViewController? {
        return storyboard.instantiateViewController(
            withIdentifier: ViewController.answersInput
            ) as? TestAnswersInputViewController
    }
}


fileprivate enum ViewController {
    static let testRecords = "com.immpi.viewControllers.testRecords"
    static let editRecord = "com.immpi.viewControllers.editRecord"
    static let answersInput = "com.immpi.viewControllers.answersInput"
    static let analysis = "com.immpi.viewControllers.analysis"
}
