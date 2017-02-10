import Foundation
import MessageUI

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

    func makeEditRecordViewController() -> EditRecordViewController {
        let controller = base.makeEditRecordViewController()
        controller.router = router
        return controller
    }

    func makeAnalysisViewController() -> AnalysisViewController {
        let controller = base.makeAnalysisViewController()
        controller.router = router
        return controller
    }

    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController {
        let controller = base.makeAnalysisOptionsViewController(context: context)

        controller.router = router
        return controller
    }

    func makeAnswersReviewViewController() -> AnswersViewController {
        let controller = base.makeAnswersReviewViewController()
        controller.router = router
        return controller
    }

    func makeAnswersInputViewController() -> AnswersInputViewController {
        let controller = base.makeAnswersInputViewController()
        controller.router = router
        return controller
    }


    func makeAnalysisReportsListViewController() -> AnalysisReportsListViewController {
        let controller = base.makeAnalysisReportsListViewController()
        controller.router = router
        return controller
    }


    func makeMailComposerViewController(for message: EmailMessage) throws -> MFMailComposeViewController {
        return try base.makeMailComposerViewController(for: message)
    }
}
