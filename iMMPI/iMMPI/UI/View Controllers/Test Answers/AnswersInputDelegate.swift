import Foundation

protocol AnswersInputDelegate: class {
    func answersViewController(_ controller: AnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: Record)

    func answersInputViewController(_ controller: AnswersViewController,
                                        didSet answers: Answers,
                                        for record: Record)
}


extension AnswersInputDelegate {
    func answersViewController(_ controller: AnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: Record) {}

    func answersInputViewController(_ controller: AnswersViewController,
                                        didSet answers: Answers,
                                        for record: Record) {}
}
