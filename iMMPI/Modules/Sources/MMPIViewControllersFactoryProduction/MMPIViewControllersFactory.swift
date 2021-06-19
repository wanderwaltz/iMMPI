import UIKit
import MessageUI
import EmailComposing
import AnalysisSettings
import MMPIRouting
import MMPIRecordEditorUI
import MMPIRecordsListUI
import MMPITestAnswersUI
import MMPIAnalysisUI
import MMPIScaleDetailsUI
import MMPIViewControllersFactory

public struct MMPIViewControllersFactory: ViewControllersFactory {
    public enum Error: Swift.Error {
        case cannotSendMail
    }

    let storyboard: UIStoryboard
    let analysisSettings: AnalysisSettings = ValidatingAnalysisSettings(UserDefaultsAnalysisSettings())

    public init(storyboard: UIStoryboard) {
        self.storyboard = storyboard
    }

    public func makeRecordsListViewController() -> RecordsListViewController {
        return RecordsListViewController(style: .plain)
    }

    public func makeEditRecordViewController() -> EditRecordViewController {
        return EditRecordViewController(style: .grouped)
    }

    public func makeAnalysisViewController() -> AnalysisViewController {
        let controller = AnalysisViewController()

        controller.settings = analysisSettings

        return controller
    }

    public func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController {
        let controller = AnalysisOptionsViewController(style: .plain)

        let actions: [MenuAction?] = [
            .print(context),
            .email(context),
            .share(context),
        ]

        controller.viewModel = AnalysisOptionsViewModel(
            settings: analysisSettings,
            actions: actions.compactMap({$0})
        )

        return controller
    }

    public func makeScaleDetailsViewController() -> ScaleDetailsViewController {
        return ScaleDetailsViewController()
    }

    public func makeAnswersReviewViewController() -> AnswersViewController {
        let controller = AnswersViewController()
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)

        tableView.rowHeight = 64.0

        tableView.dataSource = controller
        controller.tableView = tableView

        return controller
    }

    public func makeAnswersInputViewController() -> AnswersInputViewController {
        return AnswersInputViewController()
    }

    public func makeAnalysisReportsListViewController() -> AnalysisReportsListViewController {
        return AnalysisReportsListViewController(style: .plain)
    }

    public func makeMailComposerViewController(for message: EmailMessage) throws -> MFMailComposeViewController {
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
