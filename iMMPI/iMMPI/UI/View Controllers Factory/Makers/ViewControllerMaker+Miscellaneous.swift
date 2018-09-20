import UIKit

extension ViewControllerMaker {
    static let navigationController = ViewControllerMaker({ _ in
        UINavigationController()
    })

    static let formNavigationController = ViewControllerMaker({ _ in
        let controller = UINavigationController()
        controller.modalPresentationStyle = .formSheet
        return controller
    })
}
