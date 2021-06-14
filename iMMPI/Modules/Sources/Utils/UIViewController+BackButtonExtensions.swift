import UIKit

extension UIViewController {
    public func setEmptyBackBarButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: " ",
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
