import Foundation

protocol TestAnswersInputDelegate: class {
    func testAnswersViewController(_ controller: TestAnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: TestRecordProtocol)

    func testAnswersInputViewController(_ controller: TestAnswersViewController,
                                        didSet answers: TestAnswers,
                                        for record: TestRecordProtocol)
}


extension TestAnswersInputDelegate {
    func testAnswersViewController(_ controller: TestAnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: TestRecordProtocol) {}

    func testAnswersInputViewController(_ controller: TestAnswersViewController,
                                        didSet answers: TestAnswers,
                                        for record: TestRecordProtocol) {}
}
