import Foundation

protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController
    func makeAnalysisViewController() -> AnalysisViewController

    func makeEditRecordViewController() throws -> EditTestRecordViewController
    func makeAnswersInputViewController() throws -> TestAnswersInputViewController
}
