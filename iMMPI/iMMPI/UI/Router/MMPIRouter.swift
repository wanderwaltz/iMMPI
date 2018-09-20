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

        let trashButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: nil,
            action: #selector(AppDelegate.trashButtonAction(_:))
        )

        controller.navigationItem.leftBarButtonItem = trashButton

        if let navigationController = sender as? UINavigationController {
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


    func addRecord(basedOn record: Record, sender: UIViewController) {
        edit(record, title: Strings.Screen.newRecord, sender: sender)
    }


    func edit(_ record: Record, sender: UIViewController) {
        edit(record, title: Strings.Screen.editRecord, sender: sender)
    }


    func displayDetails(for records: [RecordIdentifier], sender: UIViewController) {
        guard false == records.isEmpty else {
            return
        }

        if records.count == 1 {
            displayDetailsForSingleRecord(records.first!, sender: sender)
        }
        else {
            displayDetailsForMultipleRecords(records, sender: sender)
        }
    }


    func displayAnalysis(for records: [Record], sender: UIViewController) {
        let controller = viewControllersFactory.makeAnalysisViewController()

        controller.viewModel = AnalysisViewModel(records: records)

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: records)
    }


    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnalysisOptionsViewController(context: context)

        controller.delegate = analysisOptionsDelegate

        let navigationController = UINavigationController(rootViewController: controller)
        sender.presentPopover(navigationController, animated: true, completion: nil)
    }


    func displayAnswersReview(for record: Record, sender: UIViewController) {
        guard let questionnaire = try? Questionnaire(record: record) else {
            return
        }

        let controller = viewControllersFactory.makeAnswersReviewViewController()

        controller.viewModel = DefaultAnswersViewModel(record: record, questionnaire: questionnaire)
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


    private func displayDetailsForSingleRecord(_ identifier: RecordIdentifier, sender: UIViewController) {
        guard let record = storage.all.first(where: { $0.identifier == identifier }) else {
            return
        }

        guard let questionnaire = try? Questionnaire(record: record) else {
            return
        }

        if record.answers.allStatementsAnswered(for: questionnaire) {
            displayAnalysis(for: [record], sender: sender)
        }
        else {
            displayAnswersInput(for: record, with: questionnaire, sender: sender)
        }
    }


    fileprivate func displayDetailsForMultipleRecords(_ identifiers: [RecordIdentifier], sender: UIViewController) {
        let records = identifiers.compactMap({ identifier in
            storage.all.first(where: { $0.identifier == identifier })
        })
        .sorted(by: { $0.date > $1.date })

        guard let firstRecord = records.first, records.count > 1 else {
            return
        }

        let controller = viewControllersFactory.makeRecordsListViewController()

        controller.title = firstRecord.indexItem.personName
        controller.style = .nested(basedOn: firstRecord)
        controller.grouping = .flat


        let compareButton = Views.makeSolidButton(title: Strings.Button.compare)

        compareButton.addTarget(
            controller,
            action: #selector(RecordsListViewController.compareRecordsButtonAction(_:)),
            for: .touchUpInside
        )

        controller.tableView.tableHeaderView = compareButton


        attachAddRecordButton(to: controller)

        controller.viewModel = storage.makeViewModel(includeRecord: { record in
            record.indexItem.personName.isEqual(firstRecord.indexItem.personName)
        })

        sender.show(controller, sender: sender)
    }


    fileprivate func edit(_ record: Record, title: String, sender: UIViewController) {
        let controller = viewControllersFactory.makeEditRecordViewController()

        controller.record = record
        controller.title = title
        controller.delegate = editingDelegate

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .formSheet
        sender.present(navigationController, animated: true, completion: nil)
    }


    fileprivate func displayAnswersInput(for record: Record,
                                         with questionnaire: Questionnaire,
                                         sender: UIViewController) {

        let controller = viewControllersFactory.makeAnswersInputViewController()

        controller.viewModel = DefaultAnswersViewModel(record: record, questionnaire: questionnaire)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForInput()

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }
}
