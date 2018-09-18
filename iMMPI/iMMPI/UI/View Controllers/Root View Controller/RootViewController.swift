import UIKit

final class RootViewController: UISplitViewController {
    let leftNavigationController = UINavigationController()
    let rightNavigationController = UINavigationController()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        viewControllers = [
            leftNavigationController,
            rightNavigationController,
        ]

        setupPlaceholderForRightPane()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlaceholderForRightPane() {
        let placeholder = UITableViewController(style: .plain)
        placeholder.title = Strings.Screen.rightPanePlaceholder

        rightNavigationController.viewControllers = [placeholder]
    }
}
