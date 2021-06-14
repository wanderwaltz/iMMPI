import UIKit

public protocol LastTouchedViewProviding {
    var lastTouchedView: UIView? { get }
}

protocol PopoverPresenting {
    var defaultSourceViewForPopoverPresentation: UIView? { get }

    func presentPopover(_ controller: UIViewController, animated: Bool, completion: (() -> ())?)
}


extension PopoverPresenting where Self: UIViewController {
    var defaultSourceViewForPopoverPresentation: UIView? {
        return (UIApplication.shared as? LastTouchedViewProviding)?.lastTouchedView
    }

    func presentPopover(_ controller: UIViewController, animated: Bool, completion: (() -> ())?) {
        controller.modalPresentationStyle = .popover

        if let view = defaultSourceViewForPopoverPresentation {
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = view.bounds
        }

        present(controller, animated: animated, completion: completion)
    }
}

extension UIViewController: PopoverPresenting {}
