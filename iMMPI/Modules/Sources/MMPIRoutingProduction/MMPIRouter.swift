import UIKit
import MessageUI
import EmailComposing
import HTMLComposing
import DataModel
import Analysis
import Localization
import MMPIRouting
import MMPIUI
import MMPIUITableViewCells
import MMPIRecordsListUI
import MMPITestAnswersUI
import MMPIAnalysisUI
import MMPIScaleDetailsUI
import MMPIViewControllersFactory
import MMPISoundPlayer

public final class MMPIRouter {
    let storage: RecordStorage
    let trashStorage: RecordStorage

    let viewControllersFactory: RoutedViewControllersFactory

    public init(
        factory: ViewControllersFactory,
        storage: RecordStorage,
        trashStorage: RecordStorage
    ) {
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
    public func displayAllRecords(sender: UIViewController) {
        let controller = makeRecordsList(with: storage)

        controller.title = Strings.Screen.records
        attachAddRecordButton(to: controller)

        if let navigationController = sender as? UINavigationController {
            let trashButton = UIBarButtonItem(
                barButtonSystemItem: .trash,
                target: controller,
                action: #selector(RecordsListViewController.trashButtonAction(_:))
            )

            controller.navigationItem.leftBarButtonItem = trashButton
            navigationController.viewControllers = [controller]
        }
        else {
            sender.show(controller, sender: nil)
        }
    }

    public func displayTrash(sender: UIViewController) {
        let controller = makeRecordsList(with: trashStorage)

        controller.title = Strings.Screen.trash

        // TODO: fix this; need to set the grouping for trash view controller to .flat
        // because we cannot expand gropus in trash (the lookup is performed in main storage
        // when expanding groups)
        controller.grouping = .flat

        sender.show(controller, sender: nil)
    }

    public func addRecord(basedOn record: RecordProtocol, sender: UIViewController) {
        edit(record, title: Strings.Screen.newRecord, sender: sender)
    }

    public func edit(_ record: RecordProtocol, sender: UIViewController) {
        edit(record, title: Strings.Screen.editRecord, sender: sender)
    }

    public func displayDetails(for group: RecordsGroup, sender: UIViewController) {
        if group.group.isEmpty {
            displayDetails(for: group.record, sender: sender)
        }
        else {
            expand(group, sender: sender)
        }
    }

    public func displayDetails(for record: RecordProtocol, sender: UIViewController) {
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

    public func displayAnalysis(for records: [RecordProtocol], sender: UIViewController) {
        let controller = viewControllersFactory.makeAnalysisViewController()

        controller.viewModel = AnalysisViewModel(records: records)

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: records)
    }

    public func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnalysisOptionsViewController(context: context)

        controller.delegate = analysisOptionsDelegate

        let navigationController = UINavigationController(rootViewController: controller)
        sender.presentPopover(navigationController, animated: true, completion: nil)
    }

    public func displayDetails(
        for record: RecordProtocol,
        scale: AnalysisScale,
        sender: UIViewController
    ) {
        let controller = viewControllersFactory.makeScaleDetailsViewController()
        controller.viewModel = ScaleDetailsViewModel(
            record: record,
            scale: scale
        )

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .formSheet
        sender.present(navigationController, animated: true, completion: nil)
    }

    public func displayAnswersReview(for record: RecordProtocol, sender: UIViewController) {
        guard let questionnaire = try? Questionnaire(record: record) else {
            return
        }

        let controller = viewControllersFactory.makeAnswersReviewViewController()

        controller.viewModel = DefaultAnswersViewModel(record: record, questionnaire: questionnaire)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForReview()

        sender.show(controller, sender: record)
    }

    public func displayPrintOptions(for html: Html, sender: UIViewController) {
        let printController = UIPrintInteractionController.shared
        let formatter = UIMarkupTextPrintFormatter(
            markupText: html.description
        )

        print(html.description)

        printController.printFormatter = formatter
        printController.present(from: sender.view.bounds, in: sender.view, animated: true, completionHandler: nil)
    }

    public func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {
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

    public func displayMailComposer(for email: EmailMessage, sender: UIViewController) throws {
        let mailComposer = try viewControllersFactory.makeMailComposerViewController(for: email)
        mailComposer.mailComposeDelegate = mailComposerDelegate
        sender.present(mailComposer, animated: true, completion: nil)
    }

    public func displayShareSheet(for attachments: [Attachment], sender: UIViewController) throws {
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileManager = FileManager.default

        let urls = try attachments.map { attachment -> URL in
            let url = tmp.appendingPathComponent(attachment.fileName)

            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }

            try attachment.data.write(to: url)
            return url
        }

        let shareSheet = UIActivityViewController(
            activityItems: urls,
            applicationActivities: nil
        )

        sender.presentPopover(shareSheet, animated: true, completion: nil)
    }
}

extension MMPIRouter {
    fileprivate func attachAddRecordButton(to controller: RecordsListViewController) {
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: controller,
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

        let compareButton = Views.makeSolidButton(title: Strings.Button.compare)

        compareButton.addTarget(
            controller,
            action: #selector(RecordsListViewController.compareRecordsButtonAction(_:)),
            for: .touchUpInside
        )

        controller.tableView.tableHeaderView = compareButton

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

    fileprivate func displayAnswersInput(
        for record: RecordProtocol,
        with questionnaire: Questionnaire,
        sender: UIViewController
    ) {
        let controller = viewControllersFactory.makeAnswersInputViewController()

        controller.viewModel = DefaultAnswersViewModel(record: record, questionnaire: questionnaire)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForInput()

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: record)
    }
}
