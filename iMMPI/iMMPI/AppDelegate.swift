import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let storage = try! JSONRecordsStorage(directory: .default)
    let trashStorage = try! JSONRecordsStorage(directory: .trash)

    let soundPlayer = SoundPlayer()

    let viewControllersFactory: ViewControllersFactory
    let router: Router

    override init() {
        storage.trashStorage = trashStorage
        try? storage.load()

        let viewControllersFactory = MMPIViewControllersFactory(
            storage: storage,
            trashStorage: trashStorage,
            analysisSettings: ValidatingAnalysisSettings(UserDefaultsAnalysisSettings()),
            analysisOptionsDelegate: MMPIViewControllersFactory.AnalysisOptionsDelegate(),
            editingDelegate: MMPIViewControllersFactory.EditingDelegate(storage: storage),
            mailComposerDelegate: MMPIViewControllersFactory.MailComposerDelegate(),
            reportPrintingDelegate: MMPIViewControllersFactory.ReportPrintingDelegate(),
            screenDescriptorSerialization: ScreenDescriptorSerialization()
        )

        viewControllersFactory.editingDelegate.answersInputDelegate = soundPlayer

        router = MMPIRouter(
            factory: viewControllersFactory,
            storage: storage
        )

        let routedViewControllersFactory = RoutedViewControllersFactory(
            base: viewControllersFactory
        )

        routedViewControllersFactory.router = router

        self.viewControllersFactory = routedViewControllersFactory
        super.init()
    }

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        guard NSClassFromString("XCTestCase") == nil else {
            return true
        }

        if window == nil {
            let rootViewController = makeRootViewController()

            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = rootViewController

            if let first = rootViewController.viewControllers.first {
                router.displayAllRecords(sender: first)
            }
        }

        window?.makeKeyAndVisible()
        return true
    }

    private func makeRootViewController() -> RootViewController {
        let rootVC = RootViewController()

        rootVC.delegate = self
        rootVC.minimumPrimaryColumnWidth = 300

        self.splitViewController(rootVC, willChangeTo: rootVC.displayMode)

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

        router.displayTrash(sender: root)
    }
}


// MARK: state restoration
extension AppDelegate {
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication,
                     viewControllerWithRestorationIdentifierPath identifierComponents: [String],
                     coder: NSCoder) -> UIViewController? {
        if identifierComponents.last == RootViewController.restorationIdentifier {
            return restoreRootViewController()
        }

        return nil
    }

    private func restoreRootViewController() -> UIViewController? {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = makeRootViewController()
        return window?.rootViewController
    }
}
