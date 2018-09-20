import UIKit
import MessageUI

extension ViewControllerMaker {
    static func analysisForRecords(with identifiers: [RecordIdentifier]) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            let records = identifiers.compactMap({ context.storage.findRecord(with: $0) })

            let controller = AnalysisViewController()
            controller.viewModel = AnalysisViewModel(records: records)
            controller.settings = context.analysisSettings

            return controller

        })
    }

    static func analysisOptions(with actionContext: AnalysisMenuActionContext) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            let controller = AnalysisOptionsViewController(style: .plain)
            controller.delegate = context.analysisOptionsViewControllerDelegate

            let actions: [MenuAction?] = [
                .print(actionContext),
                .email(actionContext)
            ]

            controller.viewModel = AnalysisOptionsViewModel(
                settings: context.analysisSettings,
                actions: actions.compactMap({$0})
            )

            return controller
        })
    }

    static func analysisReportsList(with actionContext: AnalysisMenuActionContext) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            let controller = AnalysisReportsListViewController(style: .plain)

            controller.delegate = context.reportListViewControllerDelegate
            controller.title = Strings.Screen.print
            controller.result = actionContext.result
            controller.reportGenerators = actionContext.htmlReportGenerators

            return controller
        })
    }

    static func mailComposer(with message: EmailMessage) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            guard case let controller = MFMailComposeViewController(), MFMailComposeViewController.canSendMail() else {
                assertionFailure("Cannot send mail")
                return UIViewController()
            }

            controller.setSubject(message.subject)
            controller.setMessageBody(message.text, isHTML: false)
            controller.setToRecipients(message.recipients.map({ $0.rawValue }))
            controller.mailComposeDelegate = context.mailComposeViewControllerDelegate

            for attachment in message.attachments {
                controller.addAttachmentData(
                    attachment.data,
                    mimeType: attachment.mimeType.rawValue,
                    fileName: attachment.fileName
                )
            }

            return controller
        })
    }
}
