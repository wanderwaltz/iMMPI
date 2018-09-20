import UIKit
import MessageUI

struct MMPIViewControllersFactory: ViewControllersFactory {
    enum Error: Swift.Error {
        case cannotSendMail
    }

    let storage: RecordStorage
    let trashStorage: RecordStorage

    let editingDelegate: EditingDelegate
    let analysisSettings: AnalysisSettings

    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController {
        let controller = AnalysisOptionsViewController(style: .plain)

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

    func makeAnalysisReportsListViewController() -> AnalysisReportsListViewController {
        return AnalysisReportsListViewController(style: .plain)
    }

    func makeMailComposerViewController(for message: EmailMessage) throws -> MFMailComposeViewController {
        guard case let controller = MFMailComposeViewController(), MFMailComposeViewController.canSendMail() else {
            throw Error.cannotSendMail
        }

        controller.setSubject(message.subject)
        controller.setMessageBody(message.text, isHTML: false)
        controller.setToRecipients(message.recipients.map({ $0.rawValue }))

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


// MARK: record lists
extension MMPIViewControllersFactory {
    func makeAllRecordsListViewController() -> RecordsListViewController {
        let controller = RecordsListViewController(style: .plain)

        controller.title = Strings.Screen.records
        controller.viewModel = storage.makeViewModel()

        attachAddRecordButton(to: controller)
        attachTrashButton(to: controller)

        return controller
    }

    func makeTrashViewController() -> RecordsListViewController {
        let controller = RecordsListViewController(style: .plain)

        controller.title = Strings.Screen.trash
        controller.viewModel = trashStorage.makeViewModel()

        // TODO: fix this; need to set the grouping for trash view controller to .flat
        // because we cannot expand gropus in trash (the lookup is performed in main storage
        // when expanding groups)
        controller.grouping = .flat

        return controller
    }

    func makeDetailsViewController(for identifier: RecordIdentifier) -> UIViewController {
        guard let record = storage.all.first(where: { $0.identifier == identifier }) else {
            return UIViewController()
        }

        guard let questionnaire = try? Questionnaire(record: record) else {
            return UIViewController()
        }

        if record.answers.allStatementsAnswered(for: questionnaire) {
            return makeAnalysisViewController(for: [record])
        }
        else {
            return makeAnswersInputViewController(for: record, questionnaire: questionnaire)
        }
    }

    func makeDetailsViewController(for identifiers: [RecordIdentifier]) -> RecordsListViewController {
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
    func makeEditRecordViewController(for record: Record, title: String) -> EditRecordViewController {
        let controller = EditRecordViewController(style: .grouped)

        controller.record = record
        controller.title =  title
        controller.delegate = editingDelegate

        return controller
    }

    func makeAnswersReviewViewController(for record: Record) -> AnswersViewController {
        let controller = AnswersViewController()
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)

        tableView.rowHeight = 64.0

        tableView.dataSource = controller
        controller.tableView = tableView

        guard let questionnaire = try? Questionnaire(record: record) else {
            return controller
        }

        controller.viewModel = DefaultAnswersViewModel(record: record, questionnaire: questionnaire)
        controller.inputDelegate = editingDelegate
        controller.cellSource = StatementTableViewCell.makeSourceForReview()

        return controller
    }

    private func makeAnswersInputViewController(for record: Record, questionnaire: Questionnaire) -> AnswersInputViewController {
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
    func makeAnalysisViewController(for records: [Record]) -> AnalysisViewController {
        let controller = AnalysisViewController()
        controller.viewModel = AnalysisViewModel(records: records)
        controller.settings = analysisSettings

        return controller
    }
}
