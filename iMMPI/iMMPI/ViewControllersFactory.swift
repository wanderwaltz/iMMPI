import Foundation
import MessageUI

protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController
    func makeEditRecordViewController() -> EditRecordViewController

    func makeAnalysisViewController() -> AnalysisViewController
    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController
    func makeAnalysisComparisonViewController() -> AnalysisComparisonViewController

    func makeAnswersReviewViewController() -> AnswersViewController
    func makeAnswersInputViewController() -> AnswersInputViewController

    func makeAnalysisReportsListViewController() -> AnalysisReportsListViewController

    func makeMailComposerViewController(for message: EmailMessage) throws -> MFMailComposeViewController
}
