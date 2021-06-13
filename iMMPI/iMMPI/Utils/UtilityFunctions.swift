import UIKit

extension UIViewController {
    func setEmptyBackBarButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}
