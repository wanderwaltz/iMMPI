import Foundation
import MessageUI
import EmailComposing
import MMPIRouting
import MMPIRecordEditorUI
import MMPIRecordsListUI
import MMPITestAnswersUI
import MMPIAnalysisUI

public protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController
    func makeEditRecordViewController() -> EditRecordViewController

    func makeAnalysisViewController() -> AnalysisViewController
    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController

    func makeAnswersReviewViewController() -> AnswersViewController
    func makeAnswersInputViewController() -> AnswersInputViewController

    func makeAnalysisReportsListViewController() -> AnalysisReportsListViewController

    func makeMailComposerViewController(for message: EmailMessage) throws -> MFMailComposeViewController
}
