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
        editingDelegate.answersInputDelegate = soundPlayer
    }

    fileprivate let editingDelegate: EditingDelegate
    fileprivate let analysisOptionsDelegate = AnalysisOptionsDelegate()
    fileprivate let soundPlayer = SoundPlayer()
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


    func addRecord(basedOn record: TestRecordProtocol, sender: UIViewController) {
        edit(record, title: Strings.newRecord, sender: sender)
    }


    func edit(_ record: TestRecordProtocol, sender: UIViewController) {
        edit(record, title: Strings.editRecord, sender: sender)
    }


    func displayDetails(for group: TestRecordsGroup, sender: UIViewController) throws {
        if group.group.isEmpty {
            try displayDetails(for: group.record, sender: sender)
        }
        else {
            expand(group, sender: sender)
        }
    }


    func displayDetails(for record: TestRecordProtocol, sender: UIViewController) throws {
        if record.testAnswers.allStatementsAnswered {
            displayAnalysis(for: record, sender: sender)
        }
        else {
            try displayAnswersInput(for: record, sender: sender)
        }
    }


    func displayAnalysis(for record: TestRecordProtocol, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnalysisViewController()

        controller.record = record
    
        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }


    func displayAnalysisOptions(sender: UIViewController, origin: UIBarButtonItem) {
        let controller = viewControllersFactory.makeAnalysisOptionsViewController()

        controller.delegate = analysisOptionsDelegate

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .popover
        navigationController.popoverPresentationController?.barButtonItem = origin
        navigationController.isNavigationBarHidden = true
        sender.present(navigationController, animated: true, completion: nil)
    }


    func displayAnswersReview(for record: TestRecordProtocol, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnswersReviewViewController()

        controller.viewModel = DefaultTestAnswersViewModel(record: record)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForReview()

        sender.show(controller, sender: record)
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


    fileprivate func edit(_ record: TestRecordProtocol, title: String, sender: UIViewController) {
        let controller = viewControllersFactory.makeEditRecordViewController()

        controller.record = record
        controller.title = title
        controller.delegate = editingDelegate

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .formSheet
        sender.present(navigationController, animated: true, completion: nil)
    }


    fileprivate func displayAnswersInput(for record: TestRecordProtocol, sender: UIViewController) throws {
        let controller = try viewControllersFactory.makeAnswersInputViewController()

        controller.viewModel = DefaultTestAnswersViewModel(record: record)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForInput()

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }
}
