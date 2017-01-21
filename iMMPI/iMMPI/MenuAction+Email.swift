import Foundation
import MessageUI

extension MenuAction {
    static func email(_ context: AnalysisMenuActionContext) -> MenuAction? {
        guard let router = context.router, MFMailComposeViewController.canSendMail() else {
            return nil
        }

        return MenuAction(title: Strings.Button.email, action: { sender in
            let message = context.emailMessageGenerator.generate(for: context.record, with: context.analyser)
            try? router.displayMailComposer(for: message, sender: sender)
        })
    }
}
