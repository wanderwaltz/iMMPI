import UIKit
import MessageUI

extension MenuAction {
    static func email(_ context: AnalysisMenuActionContext) -> MenuAction? {
        guard let router = context.router, MFMailComposeViewController.canSendMail() else {
            return nil
        }

        return MenuAction(
            title: Strings.Button.email,
            action: { sender in
                let message = context.emailMessageGenerator.generate(for: context.record, with: context.scales)
                try? router.displayMailComposer(for: message, sender: sender)
            },
            related: [
                .emailSettings()
            ])
    }


    static func emailSettings(defaults: UserDefaults = EmailRecipientsGenerator.defaultStorage,
                              key: String = EmailRecipientsGenerator.defaultKey) -> MenuAction {
        return MenuAction(title: Strings.Button.emailSettings, action: { sender in
            let alertController = UIAlertController(
                title: Strings.Screen.emailSettings,
                message: Strings.Screen.emailSettingsDescription,
                preferredStyle: .alert
            )

            var textField: UITextField!

            alertController.addTextField(configurationHandler: { tf in
                tf.placeholder = Strings.Form.emailPlaceholder
                textField = tf
            })

            alertController.addAction(UIAlertAction(title: Strings.Button.cancel, style: .cancel, handler: nil))

            alertController.addAction(UIAlertAction(title: Strings.Button.ok, style: .default, handler: { _ in
                if (textField.text ?? "").isEmpty {
                    defaults.removeObject(forKey: key)
                }
                else {
                    defaults.set([textField.text ?? ""], forKey: key)
                }

                defaults.synchronize()
            }))

            sender.present(alertController, animated: true, completion: nil)
        })
    }
}
