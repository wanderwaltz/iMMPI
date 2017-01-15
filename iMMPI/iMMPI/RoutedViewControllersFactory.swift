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

    func makeAnalysisViewController() -> AnalysisViewController {
        let controller = base.makeAnalysisViewController()
        controller.router = router
        return controller
    }

    func makeAnalysisOptionsViewController() -> AnalysisOptionsViewController {
        let controller = base.makeAnalysisOptionsViewController()
        controller.router = router
        return controller
    }

    func makeAnswersReviewViewController() -> TestAnswersViewController {
        let controller = base.makeAnswersReviewViewController()
        controller.router = router
        return controller
    }

    func makeEditRecordViewController() throws -> EditTestRecordViewController {
        let controller = try base.makeEditRecordViewController()
        controller.router = router
        return controller
    }

    func makeAnswersInputViewController() throws -> TestAnswersInputViewController {
        let controller = try base.makeAnswersInputViewController()
        controller.router = router
        return controller
    }
}
