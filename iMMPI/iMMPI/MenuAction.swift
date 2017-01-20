import Foundation

struct MenuAction {
    let title: String

    init(title: String, action: @escaping (UIViewController) -> ()) {
        self.title = title
        self.action = action
    }

    fileprivate let action: (UIViewController) -> ()
}


extension MenuAction {
    func perform(sender: UIViewController) {
        action(sender)
    }
}
