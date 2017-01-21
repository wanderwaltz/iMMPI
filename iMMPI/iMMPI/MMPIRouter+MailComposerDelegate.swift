import Foundation
import MessageUI

extension MMPIRouter {
    final class MailComposerDelegate: NSObject {}
}


extension MMPIRouter.MailComposerDelegate: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
