import Foundation

final class RoutedViewControllersFactory: ViewControllersFactory {
    weak var router: Router?

    let base: ViewControllersFactory

    init(base: ViewControllersFactory) {
        self.base = base
    }

    func makeRecordsListViewController() -> RecordsListViewController {
        let controller = base.makeRecordsListViewController()
        controller.router = router
        return controller
    }

    func makeEditRecordViewController() throws -> EditTestRecordViewController {
        let controller = try base.makeEditRecordViewController()
        return controller
    }

    func makeAnalysisViewController() throws -> AnalysisViewController {
        let controller = try base.makeAnalysisViewController()
        return controller
    }

    func makeAnswersInputViewController() throws -> TestAnswersInputViewController {
        let controller = try base.makeAnswersInputViewController()
        return controller
    }
}
