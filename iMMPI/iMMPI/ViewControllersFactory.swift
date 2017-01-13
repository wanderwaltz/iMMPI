import Foundation

protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController
    func makeAnalysisViewController() -> AnalysisViewController
    func makeAnswersReviewViewController() -> TestAnswersViewController

    func makeEditRecordViewController() throws -> EditTestRecordViewController
    func makeAnswersInputViewController() throws -> TestAnswersInputViewController

    func makeAnalysisOptionsViewController() throws -> AnalysisOptionsViewController
}
