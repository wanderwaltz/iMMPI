import UIKit
import MessageUI

struct MMPIViewControllersFactory: ViewControllersFactory {
    let storage: RecordStorage
    let trashStorage: RecordStorage

    let analysisSettings: AnalysisSettings
    let analysisOptionsDelegate: AnalysisOptionsDelegate

    let editingDelegate: EditingDelegate

    let mailComposerDelegate: MailComposerDelegate

    let reportPrintingDelegate: ReportPrintingDelegate

    func makeViewController(for descriptor: ScreenDescriptor) -> UIViewController {
        switch descriptor {
        case .allRecords:
            return makeAllRecordsListViewController()

        case .trash:
            return makeTrashViewController()

        case let .addRecord(record):
            return makeEditRecordViewController(for: record, title: Strings.Screen.newRecord)

        case let .editRecord(identifier):
            let record = storage.findRecord(with: identifier) ?? Record()
            return makeEditRecordViewController(for: record, title: Strings.Screen.editRecord)

        case let .detailsForSingleRecord(identifier):
            return makeDetailsViewController(for: identifier)

        case let .detailsForMultipleRecords(identifiers):
            return makeDetailsViewController(for: identifiers)

        case let .analysis(identifiers):
            return makeAnalysisViewController(for: identifiers)

        case let .answersInput(identifier):
            return makeAnswersInputViewController(for: identifier)

        case let .answersReview(identifier):
            return makeAnswersReviewViewController(for: identifier)

        case let .analysisOptions(context):
            return makeAnalysisOptionsViewController(context: context)

        case let .analysisReportsList(context):
            return makeAnalysisReportsListViewController(context: context)

        case let .mailComposer(message):
            return makeMailComposerViewController(for: message)
        }
    }
}


// MARK: record lists
extension MMPIViewControllersFactory {
    private func makeAllRecordsListViewController() -> RecordsListViewController {
        let controller = RecordsListViewController(style: .plain)

        controller.title = Strings.Screen.records
        controller.viewModel = storage.makeViewModel()

        attachAddRecordButton(to: controller)
        attachTrashButton(to: controller)

        return controller
    }

    private func makeTrashViewController() -> RecordsListViewController {
        let controller = RecordsListViewController(style: .plain)

        controller.title = Strings.Screen.trash
        controller.viewModel = trashStorage.makeViewModel()

        // TODO: fix this; need to set the grouping for trash view controller to .flat
        // because we cannot expand gropus in trash (the lookup is performed in main storage
        // when expanding groups)
        controller.grouping = .flat

        return controller
    }

    private func makeDetailsViewController(for identifier: RecordIdentifier) -> UIViewController {
        guard let record = storage.all.first(where: { $0.identifier == identifier }) else {
            return UIViewController()
        }

        guard let questionnaire = try? Questionnaire(record: record) else {
            return UIViewController()
        }

        if record.answers.allStatementsAnswered(for: questionnaire) {
            return makeAnalysisViewController(for: [identifier])
        }
        else {
            return makeAnswersInputViewController(for: identifier)
        }
    }

    private func makeDetailsViewController(for identifiers: [RecordIdentifier]) -> RecordsListViewController {
        let controller = RecordsListViewController(style: .plain)

        let records = identifiers.compactMap({ identifier in
            storage.all.first(where: { $0.identifier == identifier })
        })
        .sorted(by: { $0.date > $1.date })

        guard let firstRecord = records.first, records.count > 1 else {
            return controller
        }

        controller.title = firstRecord.indexItem.personName
        controller.style = .nested(basedOn: firstRecord)
        controller.grouping = .flat

        attachAddRecordButton(to: controller)
        attachCompareRecordsButton(to: controller)

        controller.viewModel = storage.makeViewModel(includeRecord: { record in
            record.indexItem.personName.isEqual(firstRecord.indexItem.personName)
        })

        return controller
    }

    private func attachAddRecordButton(to controller: UIViewController) {
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: nil,
            action: #selector(RecordsListViewController.addRecordButtonAction(_:))
        )

        controller.navigationItem.rightBarButtonItem = button
    }

    private func attachTrashButton(to controller: UIViewController) {
        let button = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: nil,
            action: #selector(AppDelegate.trashButtonAction(_:))
        )

        controller.navigationItem.leftBarButtonItem = button
    }

    private func attachCompareRecordsButton(to controller: UITableViewController) {
        let compareButton = Views.makeSolidButton(title: Strings.Button.compare)

        compareButton.addTarget(
            controller,
            action: #selector(RecordsListViewController.compareRecordsButtonAction(_:)),
            for: .touchUpInside
        )

        controller.tableView.tableHeaderView = compareButton
    }
}


// MARK: record details & editing
extension MMPIViewControllersFactory {
    private func makeEditRecordViewController(for record: Record, title: String) -> EditRecordViewController {
        let controller = EditRecordViewController(style: .grouped)

        controller.record = record
        controller.title =  title
        controller.delegate = editingDelegate

        return controller
    }

    private func makeAnswersReviewViewController(for identifier: RecordIdentifier) -> UIViewController {
        guard let record = storage.findRecord(with: identifier) else {
            assertionFailure("Could not find record with identifier: \(identifier)")
            return UIViewController()
        }

        let controller = AnswersViewController()
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)

        tableView.rowHeight = 64.0

        tableView.dataSource = controller
        controller.tableView = tableView

        guard let questionnaire = try? Questionnaire(record: record) else {
            assertionFailure("Failed loading questionnaire for record with identifier: \(identifier)")
            return controller
        }

        controller.viewModel = DefaultAnswersViewModel(record: record, questionnaire: questionnaire)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForReview()

        return controller
    }

    private func makeAnswersInputViewController(for identifier: RecordIdentifier) -> UIViewController {
        guard let record = storage.findRecord(with: identifier) else {
            assertionFailure("Could not find record with identifier: \(identifier)")
            return UIViewController()
        }

        guard let questionnaire = try? Questionnaire(record: record) else {
            assertionFailure("Failed loading questionnaire for record with identifier: \(identifier)")
            return UIViewController()
        }

        let controller = AnswersInputViewController(
            nibName: "AnswersInputViewController",
            bundle: Bundle(for: AnswersInputViewController.self)
        )

        controller.viewModel = DefaultAnswersViewModel(record: record, questionnaire: questionnaire)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForInput()

        return controller
    }
}


// MARK: analysis
extension MMPIViewControllersFactory {
    private func makeAnalysisViewController(for identifiers: [RecordIdentifier]) -> AnalysisViewController {
        let records = identifiers.compactMap({ storage.findRecord(with: $0) })

        let controller = AnalysisViewController()
        controller.viewModel = AnalysisViewModel(records: records)
        controller.settings = analysisSettings

        return controller
    }

    private func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController {
        let controller = AnalysisOptionsViewController(style: .plain)
        controller.delegate = analysisOptionsDelegate

        let actions: [MenuAction?] = [
            .print(context),
            .email(context)
        ]

        controller.viewModel = AnalysisOptionsViewModel(
            settings: analysisSettings,
            actions: actions.compactMap({$0})
        )

        return controller
    }

    private func makeAnalysisReportsListViewController(context: AnalysisMenuActionContext) -> AnalysisReportsListViewController {
        let controller = AnalysisReportsListViewController(style: .plain)

        controller.delegate = reportPrintingDelegate
        controller.title = Strings.Screen.print
        controller.result = context.result
        controller.reportGenerators = context.htmlReportGenerators

        return controller
    }

    private func makeMailComposerViewController(for message: EmailMessage) -> UIViewController {
        guard case let controller = MFMailComposeViewController(), MFMailComposeViewController.canSendMail() else {
            assertionFailure("Cannot send mail")
            return UIViewController()
        }

        controller.setSubject(message.subject)
        controller.setMessageBody(message.text, isHTML: false)
        controller.setToRecipients(message.recipients.map({ $0.rawValue }))
        controller.mailComposeDelegate = mailComposerDelegate

        for attachment in message.attachments {
            controller.addAttachmentData(
                attachment.data,
                mimeType: attachment.mimeType.rawValue,
                fileName: attachment.fileName
            )
        }

        return controller
    }
}
