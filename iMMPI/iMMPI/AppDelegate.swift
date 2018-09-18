import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let storage = try! JSONRecordsStorage(directoryName: kJSONRecordStorageDirectoryDefault)
    let trashStorage = try! JSONRecordsStorage(directoryName: kJSONRecordStorageDirectoryTrash)

    var router: Router?

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        guard NSClassFromString("XCTestCase") == nil else {
            return true
        }

        storage.trashStorage = trashStorage

        let viewControllersFactory = MMPIViewControllersFactory()

        router = MMPIRouter(
            factory: viewControllersFactory,
            storage: storage,
            trashStorage: trashStorage
        )

        if let splitViewController = window?.rootViewController as? UISplitViewController {
            splitViewController.delegate = self
            splitViewController.minimumPrimaryColumnWidth = 300

            self.splitViewController(splitViewController, willChangeTo: splitViewController.displayMode)

            if let first = splitViewController.viewControllers.first {
                router?.displayAllRecords(sender: first)
            }
        }

        return true
    }
}


extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        assert(svc.viewControllers.count == 2,
            "Unexpected number of child view controllers in \(svc): \(svc.viewControllers.count)")

        guard let detailViewController = svc.viewControllers.last?.mmpiSelfOrFirstChild else {
            return
        }

        let barButtonItem = svc.displayModeButtonItem

        switch displayMode {
        case .primaryHidden: fallthrough
        case .primaryOverlay:
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
    @IBAction func trashButtonAction(_ sender: Any?) {
        guard let root = (window?.rootViewController as? UISplitViewController)?.viewControllers.first else {
            return
        }

        router?.displayTrash(sender: root)
    }
}
