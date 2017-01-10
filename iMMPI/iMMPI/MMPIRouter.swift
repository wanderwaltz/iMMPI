import UIKit

final class MMPIRouter {
    let storage: TestRecordStorage
    let trashStorage: TestRecordStorage

    let viewControllersFactory: RoutedViewControllersFactory

    init(factory: ViewControllersFactory, storage: TestRecordStorage, trashStorage: TestRecordStorage) {
        self.viewControllersFactory = RoutedViewControllersFactory(base: factory)
        self.storage = storage
        self.trashStorage = trashStorage
        self.editingDelegate = EditingDelegate(storage: storage)

        viewControllersFactory.router = self
    }

    fileprivate let editingDelegate: EditingDelegate
}


extension MMPIRouter: Router {
    func displayAllRecords(sender: UIViewController) {
        let controller = makeRecordsList(with: storage)

        controller.title = Strings.records
        attachAddRecordButton(to: controller)

        if let navigationController = sender as? UINavigationController {
            let trashButton = UIBarButtonItem(
                barButtonSystemItem: .trash,
                target: nil,
                action: #selector(AppDelegate.trashButtonAction(_:))
            )

            controller.navigationItem.leftBarButtonItem = trashButton
            navigationController.viewControllers = [controller]
        }
        else {
            sender.show(controller, sender: nil)
        }
    }


    func displayTrash(sender: UIViewController) {
        let controller = makeRecordsList(with: trashStorage)

        controller.title = Strings.trash
        controller.grouping = .flat

        sender.show(controller, sender: nil)
    }


    func displayDetails(for group: TestRecordsGroup, sender: UIViewController) throws {
        if group.group.isEmpty {
            try displayDetails(for: group.record, sender: sender)
        }
        else {
            expand(group, sender: sender)
        }
    }


    func edit(_ record: TestRecordProtocol, sender: UIViewController) throws {
        let controller = try viewControllersFactory.makeEditRecordViewController()

        controller.record = record
        controller.title = Strings.editRecord
        controller.delegate = editingDelegate

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .formSheet
        sender.present(navigationController, animated: true, completion: nil)
    }


    func displayAnswersInput(for record: TestRecordProtocol, sender: UIViewController) throws {
        let controller = try viewControllersFactory.makeAnswersInputViewController()

        controller.setRecordToEditAnswers(record)
        controller.setStorageToEditAnswers(storage)

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }
}


extension MMPIRouter {
    fileprivate func attachAddRecordButton(to controller: UIViewController) {
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: nil,
            action: #selector(RecordsListViewController.addRecordButtonAction(_:))
        )
        
        controller.navigationItem.rightBarButtonItem = button
    }


    fileprivate func makeRecordsList(with storage: TestRecordStorage) -> RecordsListViewController {
        let controller = viewControllersFactory.makeRecordsListViewController()
        controller.viewModel = storage.makeViewModel()

        return controller
    }


    fileprivate func expand(_ group: TestRecordsGroup, sender: UIViewController) {
        let controller = viewControllersFactory.makeRecordsListViewController()

        controller.title = group.personName
        controller.style = .nested(basedOn: group.record)
        controller.grouping = .flat

        attachAddRecordButton(to: controller)

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
        let controller = try viewControllersFactory.makeAnalysisViewController()

        controller.setRecordForAnalysis(record)
        controller.setStorageForAnalysis(storage)

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }
}
