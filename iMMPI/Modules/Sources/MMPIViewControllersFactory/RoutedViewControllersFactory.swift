import Foundation
import MessageUI
import EmailComposing
import MMPIRouting
import MMPIRecordEditorUI
import MMPIRecordsListUI
import MMPITestAnswersUI
import MMPIAnalysisUI
import MMPIScaleDetailsUI

public final class RoutedViewControllersFactory: ViewControllersFactory {
    public weak var router: Router?

    let base: ViewControllersFactory

    public init(base: ViewControllersFactory) {
        self.base = base
    }

    public func makeRecordsListViewController() -> RecordsListViewController {
        let controller = base.makeRecordsListViewController()
        controller.router = router
        return controller
    }

    public func makeEditRecordViewController() -> EditRecordViewController {
        let controller = base.makeEditRecordViewController()
        controller.router = router
        return controller
    }

    public func makeAnalysisViewController() -> AnalysisViewController {
        let controller = base.makeAnalysisViewController()
        controller.router = router
        return controller
    }

    public func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController {
        let controller = base.makeAnalysisOptionsViewController(context: context)

        controller.router = router
        return controller
    }

    public func makeScaleDetailsViewController() -> ScaleDetailsViewController {
        let controller = base.makeScaleDetailsViewController()

        controller.router = router
        return controller
    }

    public func makeAnswersReviewViewController() -> AnswersViewController {
        let controller = base.makeAnswersReviewViewController()
        controller.router = router
        return controller
    }

    public func makeAnswersInputViewController() -> AnswersInputViewController {
        let controller = base.makeAnswersInputViewController()
        controller.router = router
        return controller
    }

    public func makeAnalysisReportsListViewController() -> AnalysisReportsListViewController {
        let controller = base.makeAnalysisReportsListViewController()
        controller.router = router
        return controller
    }

    public func makeMailComposerViewController(for message: EmailMessage) throws -> MFMailComposeViewController {
        return try base.makeMailComposerViewController(for: message)
    }
}
