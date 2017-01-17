import Foundation

protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController
    func makeEditRecordViewController() -> EditTestRecordViewController

    func makeAnalysisViewController() -> AnalysisViewController
    func makeAnalysisOptionsViewController() -> AnalysisOptionsViewController

    func makeAnswersReviewViewController() -> TestAnswersViewController

    func makeAnswersInputViewController() throws -> TestAnswersInputViewController

}
