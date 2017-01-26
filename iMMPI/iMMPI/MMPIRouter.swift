import UIKit
import MessageUI

final class MMPIRouter {
    let storage: RecordStorage
    let trashStorage: RecordStorage

    let viewControllersFactory: RoutedViewControllersFactory

    init(factory: ViewControllersFactory, storage: RecordStorage, trashStorage: RecordStorage) {
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
    fileprivate let mailComposerDelegate = MailComposerDelegate()
    fileprivate let soundPlayer = SoundPlayer()
}


extension MMPIRouter: Router {
    func displayAllRecords(sender: UIViewController) {
        let controller = makeRecordsList(with: storage)

        controller.title = Strings.Screen.records
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

        // TODO: fix this; need to set the grouping for trash view controller to .flat
        // because we cannot expand gropus in trash (the lookup is performed in main storage
        // when expanding groups)
        controller.grouping = .flat

        sender.show(controller, sender: nil)
    }


    func addRecord(basedOn record: RecordProtocol, sender: UIViewController) {
        edit(record, title: Strings.Screen.newRecord, sender: sender)
    }


    func edit(_ record: RecordProtocol, sender: UIViewController) {
        edit(record, title: Strings.Screen.editRecord, sender: sender)
    }


    func displayDetails(for group: RecordsGroup, sender: UIViewController) {
        if group.group.isEmpty {
            displayDetails(for: group.record, sender: sender)
        }
        else {
            expand(group, sender: sender)
        }
    }


    func displayDetails(for record: RecordProtocol, sender: UIViewController) {
        if record.testAnswers.allStatementsAnswered {
            displayAnalysis(for: record, sender: sender)
        }
        else {
            displayAnswersInput(for: record, sender: sender)
        }
    }


    func displayAnalysis(for record: RecordProtocol, sender: UIViewController) {
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


    func displayAnswersReview(for record: RecordProtocol, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnswersReviewViewController()

        controller.viewModel = DefaultAnswersViewModel(record: record)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForReview()

        sender.show(controller, sender: record)
    }


    func displayPrintOptions(for html: Html, sender: UIViewController) {
        let printController = UIPrintInteractionController.shared
        let formatter = UIMarkupTextPrintFormatter(
            markupText: html.description
        )

        print(html.description)

        printController.printFormatter = formatter
        printController.present(from: sender.view.bounds, in: sender.view, animated: true, completionHandler: nil)
    }


    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {
        let reportGenerators = context.htmlReportGenerators

        guard reportGenerators.count > 0 else {
            return
        }

        if reportGenerators.count > 1 {
            let controller = viewControllersFactory.makeAnalysisReportsListViewController()

            controller.delegate = reportPrintingDelegate
            controller.title = Strings.Screen.print
            controller.result = context.result
            controller.reportGenerators = reportGenerators
            
            sender.show(controller, sender: context)
        }
        else {
            let html = reportGenerators.first!.generate(for: context.result)
            displayPrintOptions(for: html, sender: sender)
        }
    }


    func displayMailComposer(for email: EmailMessage, sender: UIViewController) throws {
        let mailComposer = try viewControllersFactory.makeMailComposerViewController(for: email)
        mailComposer.mailComposeDelegate = mailComposerDelegate
        sender.present(mailComposer, animated: true, completion: nil)
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


    fileprivate func makeRecordsList(with storage: RecordStorage) -> RecordsListViewController {
        let controller = viewControllersFactory.makeRecordsListViewController()
        controller.viewModel = storage.makeViewModel()

        return controller
    }


    fileprivate func expand(_ group: RecordsGroup, sender: UIViewController) {
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


    fileprivate func edit(_ record: RecordProtocol, title: String, sender: UIViewController) {
        let controller = viewControllersFactory.makeEditRecordViewController()

        controller.record = record
        controller.title = title
        controller.delegate = editingDelegate

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .formSheet
        sender.present(navigationController, animated: true, completion: nil)
    }


    fileprivate func displayAnswersInput(for record: RecordProtocol, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnswersInputViewController()

        controller.viewModel = DefaultAnswersViewModel(record: record)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForInput()

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }
}
