import UIKit

extension UIContextualAction {
    convenience init(_ menuAction: MenuAction, sender: UIViewController) {
        self.init(style: .normal, title: menuAction.title, handler: { [weak sender] _, _, _ in
            guard let sender = sender else {
                return
            }

            menuAction.perform(sender: sender)
        })
    }
}
