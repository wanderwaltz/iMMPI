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
    fileprivate let reportPrintingDelegate = ReportPrintingDelegate()
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

        controller.title = Strings.Screen.trash
        controller.grouping = .flat

        sender.show(controller, sender: nil)
    }


    func addRecord(basedOn record: TestRecordProtocol, sender: UIViewController) {
        edit(record, title: Strings.Screen.newRecord, sender: sender)
    }


    func edit(_ record: TestRecordProtocol, sender: UIViewController) {
        edit(record, title: Strings.Screen.editRecord, sender: sender)
    }


    func displayDetails(for group: TestRecordsGroup, sender: UIViewController) {
        if group.group.isEmpty {
            displayDetails(for: group.record, sender: sender)
        }
        else {
            expand(group, sender: sender)
        }
    }


    func displayDetails(for record: TestRecordProtocol, sender: UIViewController) {
        if record.testAnswers.allStatementsAnswered {
            displayAnalysis(for: record, sender: sender)
        }
        else {
            displayAnswersInput(for: record, sender: sender)
        }
    }


    func displayAnalysis(for record: TestRecordProtocol, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnalysisViewController()

        controller.record = record
    
        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }


    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnalysisOptionsViewController(context: context)

        controller.delegate = analysisOptionsDelegate

        let navigationController = UINavigationController(rootViewController: controller)
        sender.presentPopover(navigationController, animated: true, completion: nil)
    }


    func displayAnswersReview(for record: TestRecordProtocol, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnswersReviewViewController()

        controller.viewModel = DefaultTestAnswersViewModel(record: record)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForReview()

        sender.show(controller, sender: record)
    }


    func displayPrintOptions(for html: Html, sender: UIViewController) {
        let printController = UIPrintInteractionController.shared
        let formatter = UIMarkupTextPrintFormatter(
            markupText: html.description
        )

        printController.printFormatter = formatter
        printController.present(from: sender.view.bounds, in: sender.view, animated: true, completionHandler: nil)
    }


    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {
        let reportGenerators: [HtmlReportGenerator] = [
            .overall
        ]

        guard reportGenerators.count > 0 else {
            return
        }

        if reportGenerators.count > 1 {
            let controller = viewControllersFactory.makeAnalysisReportsListViewController()

            controller.delegate = reportPrintingDelegate
            controller.title = Strings.Screen.print
            controller.record = context.record
            controller.analyser = context.analyser
            controller.reportGenerators = [
                .overall
            ]
            
            sender.show(controller, sender: context)
        }
        else {
            let html = reportGenerators.first!.generate(for: context.record, with: context.analyser)
            displayPrintOptions(for: html, sender: sender)
        }
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


    fileprivate func displayAnswersInput(for record: TestRecordProtocol, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnswersInputViewController()

        controller.viewModel = DefaultTestAnswersViewModel(record: record)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForInput()

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }
}
