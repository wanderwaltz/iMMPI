import Foundation
import MessageUI
import EmailComposing

protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController
    func makeEditRecordViewController() -> EditRecordViewController

    func makeAnalysisViewController() -> AnalysisViewController
    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController

    func makeAnswersReviewViewController() -> AnswersViewController
    func makeAnswersInputViewController() -> AnswersInputViewController

    func makeAnalysisReportsListViewController() -> AnalysisReportsListViewController

    func makeMailComposerViewController(for message: EmailMessage) throws -> MFMailComposeViewController
}
