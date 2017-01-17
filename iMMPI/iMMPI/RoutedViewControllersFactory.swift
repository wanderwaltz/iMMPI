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

    func makeEditRecordViewController() -> EditTestRecordViewController {
        let controller = base.makeEditRecordViewController()
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

    func makeAnswersInputViewController() -> TestAnswersInputViewController {
        let controller = base.makeAnswersInputViewController()
        controller.router = router
        return controller
    }
}
