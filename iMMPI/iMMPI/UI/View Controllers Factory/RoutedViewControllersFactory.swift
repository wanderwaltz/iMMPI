import Foundation
import MessageUI

final class RoutedViewControllersFactory: ViewControllersFactory {
    weak var router: Router?

    let base: ViewControllersFactory

    init(base: ViewControllersFactory) {
        self.base = base
    }

    func makeAllRecordsListViewController() -> RecordsListViewController {
        let controller = base.makeAllRecordsListViewController()
        controller.router = router
        return controller
    }

    func makeTrashViewController() -> RecordsListViewController {
        let controller = base.makeTrashViewController()
        controller.router = router
        return controller
    }

    func makeDetailsViewController(for recordIdentifier: RecordIdentifier) -> UIViewController {
        let controller = base.makeDetailsViewController(for: recordIdentifier)

        if let usingRouting = controller as? UsingRouting {
            usingRouting.router = router
        }

        return controller
    }

    func makeDetailsViewController(for recordIdentifiers: [RecordIdentifier]) -> RecordsListViewController {
        let controller = base.makeDetailsViewController(for: recordIdentifiers)
        controller.router = router
        return controller
    }

    func makeEditRecordViewController(for record: Record, title: String) -> EditRecordViewController {
        let controller = base.makeEditRecordViewController(for: record, title: title)
        controller.router = router
        return controller
    }

    func makeAnalysisViewController(for records: [Record]) -> AnalysisViewController {
        let controller = base.makeAnalysisViewController(for: records)
        controller.router = router
        return controller
    }

    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController {
        let controller = base.makeAnalysisOptionsViewController(context: context)

        controller.router = router
        return controller
    }

    func makeAnswersReviewViewController(for record: Record) -> AnswersViewController {
        let controller = base.makeAnswersReviewViewController(for: record)
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
