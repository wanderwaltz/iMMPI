import Foundation
import MessageUI

extension MMPIViewControllersFactory {
    final class MailComposerDelegate: NSObject {}
}


extension MMPIViewControllersFactory.MailComposerDelegate: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
