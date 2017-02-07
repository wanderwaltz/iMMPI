import Foundation

protocol AnswersInputDelegate: class {
    func answersViewController(_ controller: AnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: RecordProtocol)

    func answersInputViewController(_ controller: AnswersViewController,
                                        didSet answers: Answers,
                                        for record: RecordProtocol)
}


extension AnswersInputDelegate {
    func answersViewController(_ controller: AnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: RecordProtocol) {}

    func answersInputViewController(_ controller: AnswersViewController,
                                        didSet answers: Answers,
                                        for record: RecordProtocol) {}
}
