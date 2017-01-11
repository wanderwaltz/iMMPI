import Foundation

protocol TestAnswersInputDelegate: class {
    func testAnswersViewController(_ controller: TestAnswersTableViewControllerBase,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: TestRecordProtocol)
}
