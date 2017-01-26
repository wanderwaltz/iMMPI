import Foundation

protocol AnswersInputDelegate: class {
    func testAnswersViewController(_ controller: AnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: RecordProtocol)

    func testAnswersInputViewController(_ controller: AnswersViewController,
                                        didSet answers: Answers,
                                        for record: RecordProtocol)
}


extension AnswersInputDelegate {
    func testAnswersViewController(_ controller: AnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: RecordProtocol) {}

    func testAnswersInputViewController(_ controller: AnswersViewController,
                                        didSet answers: Answers,
                                        for record: RecordProtocol) {}
}
