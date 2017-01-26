import Foundation

protocol TestAnswersInputDelegate: class {
    func testAnswersViewController(_ controller: TestAnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: RecordProtocol)

    func testAnswersInputViewController(_ controller: TestAnswersViewController,
                                        didSet answers: TestAnswers,
                                        for record: RecordProtocol)
}


extension TestAnswersInputDelegate {
    func testAnswersViewController(_ controller: TestAnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: RecordProtocol) {}

    func testAnswersInputViewController(_ controller: TestAnswersViewController,
                                        didSet answers: TestAnswers,
                                        for record: RecordProtocol) {}
}
