import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let storage = try! JSONRecordsStorage(directory: .default)
    let trashStorage = try! JSONRecordsStorage(directory: .trash)
    let soundPlayer = SoundPlayer()

    var router: Router?

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        guard NSClassFromString("XCTestCase") == nil else {
            return true
        }

        storage.trashStorage = trashStorage

        let viewControllersFactory = MMPIViewControllersFactory(
            storage: storage,
            trashStorage: trashStorage,
            editingDelegate: MMPIViewControllersFactory.EditingDelegate(storage: storage),
            analysisSettings: ValidatingAnalysisSettings(UserDefaultsAnalysisSettings())
        )

        viewControllersFactory.editingDelegate.answersInputDelegate = soundPlayer

        router = MMPIRouter(
            factory: viewControllersFactory,
            storage: storage
        )

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()

        return true
    }

    private func makeRootViewController() -> RootViewController {
        let rootVC = RootViewController()

        rootVC.delegate = self
        rootVC.minimumPrimaryColumnWidth = 300

        self.splitViewController(rootVC, willChangeTo: rootVC.displayMode)

        if let first = rootVC.viewControllers.first {
            router?.displayAllRecords(sender: first)
        }

        return rootVC
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
