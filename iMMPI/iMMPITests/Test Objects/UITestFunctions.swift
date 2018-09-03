import UIKit

extension UIBarButtonItem {
    func click() {
        _ = target?.perform(action, with: self)
    }
}
