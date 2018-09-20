import Foundation
import MessageUI

protocol ViewControllersFactory {
    func makeAllRecordsListViewController() -> RecordsListViewController
    func makeTrashViewController() -> RecordsListViewController

    func makeEditRecordViewController(for record: Record, title: String) -> EditRecordViewController

    func makeDetailsViewController(for recordIdentifier: RecordIdentifier) -> UIViewController
    func makeDetailsViewController(for recordIdentifiers: [RecordIdentifier]) -> RecordsListViewController

    func makeAnalysisViewController(for records: [Record]) -> AnalysisViewController
    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController

    func makeAnswersReviewViewController(for record: Record) -> AnswersViewController

    func makeAnalysisReportsListViewController() -> AnalysisReportsListViewController

    func makeMailComposerViewController(for message: EmailMessage) throws -> MFMailComposeViewController
}
