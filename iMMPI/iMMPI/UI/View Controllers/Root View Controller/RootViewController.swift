import UIKit

final class RootViewController: UISplitViewController {
    static let restorationIdentifier = "root"

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        restorationIdentifier = RootViewController.restorationIdentifier

        let leftNavigationController = UINavigationController()
        let rightNavigationController = UINavigationController()

        leftNavigationController.restorationIdentifier =
            ScreenDescriptorSerialization.RestorationIdentifier.navigationController

        rightNavigationController.restorationIdentifier =
            ScreenDescriptorSerialization.RestorationIdentifier.navigationController

        viewControllers = [
            leftNavigationController,
            rightNavigationController
        ]

        setupPlaceholder(for: rightNavigationController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlaceholder(for rightNavigationController: UINavigationController) {
        let placeholder = UITableViewController(style: .plain)
        placeholder.title = Strings.Screen.rightPanePlaceholder

        rightNavigationController.viewControllers = [placeholder]
    }
}
