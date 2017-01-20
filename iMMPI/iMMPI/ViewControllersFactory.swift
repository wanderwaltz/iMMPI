import Foundation

protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController
    func makeEditRecordViewController() -> EditTestRecordViewController

    func makeAnalysisViewController() -> AnalysisViewController
    func makeAnalysisOptionsViewController(context: AnalysisMenuActionContext) -> AnalysisOptionsViewController

    func makeAnswersReviewViewController() -> TestAnswersViewController
    func makeAnswersInputViewController() -> TestAnswersInputViewController
}
