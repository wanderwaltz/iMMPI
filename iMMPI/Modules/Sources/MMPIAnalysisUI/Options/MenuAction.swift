import UIKit

public struct MenuAction {
    let title: String
    let relatedActions: [MenuAction]

    public init(
        title: String,
        action: @escaping (UIViewController) -> (),
        related: [MenuAction] = []
    ) {
        self.title = title
        self.action = action
        self.relatedActions = related
    }

    fileprivate let action: (UIViewController) -> ()
}


extension MenuAction {
    func perform(sender: UIViewController) {
        action(sender)
    }
}
