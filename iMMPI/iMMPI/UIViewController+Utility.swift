import UIKit

extension UIViewController {
    var mmpiSelfOrFirstChild: UIViewController {
        return (self as? UINavigationController)?.viewControllers.first ?? self
    }
}
