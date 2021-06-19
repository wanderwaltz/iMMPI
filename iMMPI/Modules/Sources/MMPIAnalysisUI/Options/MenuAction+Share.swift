import UIKit
import MessageUI
import Localization
import AnalysisReports
import MMPIRouting

extension MenuAction {
    public static func share(_ context: AnalysisMenuActionContext) -> MenuAction? {
        guard let router = context.router else {
            return nil
        }

        return MenuAction(
            title: Strings.Button.share,
            action: { sender in
                let message = context.emailMessageGenerator.generate(for: context.result)
                try? router.displayShareSheet(for: message.attachments, sender: sender)
            }
        )
    }
}
