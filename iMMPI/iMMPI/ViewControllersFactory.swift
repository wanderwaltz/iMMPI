import Foundation

protocol ViewControllersFactory {
    func makeRecordsListViewController() -> RecordsListViewController

    func makeEditRecordViewController() throws -> EditTestRecordViewController
    func makeAnalysisViewController() throws -> AnalysisViewController
    func makeAnswersInputViewController() throws -> TestAnswersInputViewController
}
