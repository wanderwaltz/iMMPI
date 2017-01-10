import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let storage = JSONTestRecordsStorage(directoryName: kJSONTestRecordStorageDirectoryDefault)
    let trashStorage = JSONTestRecordsStorage(directoryName: kJSONTestRecordStorageDirectoryTrash)

    var router: Router?

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        storage.trashStorage = trashStorage
        router = MMPIRouter(
            storyboard: window!.rootViewController!.storyboard!,
            storage: storage,
            trashStorage: trashStorage
        )

        if let splitViewController = window?.rootViewController as? UISplitViewController {
            splitViewController.delegate = self
            splitViewController.minimumPrimaryColumnWidth = 300

            self.splitViewController(splitViewController, willChangeTo: splitViewController.displayMode)

            if let recordsList = SelfOrFirstChild(splitViewController.viewControllers.first)
                as? RecordsListViewController {
                recordsList.router = router
                recordsList.viewModel = storage.makeViewModel()
            }
        }

        return true
    }
}


extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        assert(svc.viewControllers.count == 2,
            "Unexpected number of child view controllers in \(svc): \(svc.viewControllers.count)")

        guard let detailViewController = SelfOrFirstChild(svc.viewControllers.last) else {
            return
        }

        let barButtonItem = svc.displayModeButtonItem

        switch displayMode {
        case .primaryHidden: fallthrough
        case .primaryOverlay:
            barButtonItem.title = Strings.records

            if detailViewController.navigationItem.leftBarButtonItem == nil {
                detailViewController.navigationItem.leftBarButtonItem = barButtonItem
            }

        default:
            if detailViewController.navigationItem.leftBarButtonItem == barButtonItem {
                detailViewController.navigationItem.leftBarButtonItem = nil
            }
        }
    }
}


extension AppDelegate {
    @objc @IBAction fileprivate func trashButtonAction(_ sender: Any?) {
        guard let root = (window?.rootViewController as? UISplitViewController)?.viewControllers.first else {
            return
        }

        try? router?.displayTrash(sender: root)
    }
}
