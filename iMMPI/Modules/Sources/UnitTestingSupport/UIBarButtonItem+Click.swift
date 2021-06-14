import UIKit

extension UIBarButtonItem {
    public func click() {
        _ = target?.perform(action, with: self)
    }
}
