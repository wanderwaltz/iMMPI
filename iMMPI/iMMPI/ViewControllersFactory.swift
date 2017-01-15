import Foundation

protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController

    func makeAnalysisViewController() -> AnalysisViewController
    func makeAnalysisOptionsViewController() -> AnalysisOptionsViewController

    func makeAnswersReviewViewController() -> TestAnswersViewController

    func makeEditRecordViewController() throws -> EditTestRecordViewController
    func makeAnswersInputViewController() throws -> TestAnswersInputViewController

}
