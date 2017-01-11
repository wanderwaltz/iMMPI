import Foundation

protocol TestAnswersInputDelegate: class {
    func testAnswersViewController(_ controller: TestAnswersTableViewControllerBase,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: TestRecordProtocol)

    func testAnswersInputViewController(_ controller: TestAnswersTableViewControllerBase,
                                        didSet answers: TestAnswersProtocol,
                                        for record: TestRecordProtocol)
}


extension TestAnswersInputDelegate {
    func testAnswersViewController(_ controller: TestAnswersTableViewControllerBase,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: TestRecordProtocol) {}

    func testAnswersInputViewController(_ controller: TestAnswersTableViewControllerBase,
                                        didSet answers: TestAnswersProtocol,
                                        for record: TestRecordProtocol) {}
}
