import Foundation
import MessageUI

protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController
    func makeEditRecordViewController() -> EditTestRecordViewController

    func makeAnalysisViewController() -> AnalysisViewController
    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController

    func makeAnswersReviewViewController() -> TestAnswersViewController
    func makeAnswersInputViewController() -> TestAnswersInputViewController

    func makeAnalysisReportsListViewController() -> AnalysisReportsListViewController

    func makeMailComposerViewController(for message: EmailMessage) throws -> MFMailComposeViewController
}
