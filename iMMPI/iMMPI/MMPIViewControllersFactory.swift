import UIKit
import MessageUI

struct MMPIViewControllersFactory: ViewControllersFactory {
    enum Error: Swift.Error {
        case cannotSendMail
    }


    let storyboard: UIStoryboard
    let analysisSettings: AnalysisSettings = ValidatingAnalysisSettings(UserDefaultsAnalysisSettings())


    func makeRecordsListViewController() -> RecordsListViewController {
        return RecordsListViewController(style: .plain)
    }


    func makeEditRecordViewController() -> EditRecordViewController {
        return EditRecordViewController(style: .grouped)
    }


    func makeAnalysisViewController() -> AnalysisViewController {
        let controller = AnalysisViewController(style: .plain)

        controller.settings = analysisSettings
        controller.cellSource = AnalyserTableViewCell.makeSource(with: .default(with: analysisSettings))

        return controller
    }


    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController {
        let controller = AnalysisOptionsViewController(style: .plain)

        let actions: [MenuAction?] = [
            .print(context),
            .email(context)
        ]

        controller.viewModel = AnalysisOptionsViewModel(
            settings: analysisSettings,
            actions: actions.flatMap({$0})
        )

        return controller
    }


    func makeAnswersReviewViewController() -> TestAnswersViewController {
        let controller = TestAnswersViewController()
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)

        tableView.rowHeight = 64.0

        tableView.dataSource = controller
        controller.tableView = tableView

        return controller
    }


    func makeAnswersInputViewController() -> TestAnswersInputViewController {
        return TestAnswersInputViewController(
            nibName: "TestAnswersInputViewController",
            bundle: Bundle(for: TestAnswersInputViewController.self)
        )
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
