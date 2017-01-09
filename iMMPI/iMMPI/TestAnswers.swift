import Foundation

final class TestAnswers: NSObject {
    override init() {
        super.init()
    }

    fileprivate var answersByIdentifier: [Int:Record] = [:]
}


extension TestAnswers: TestAnswersProtocol {
    func allStatementsAnswered() -> Bool {
        // TODO: think of a better way to check this
        return answersByIdentifier.count == 566
    }


    func setAnswer(_ answer: AnswerType, for identifier: Int) {
        answersByIdentifier[identifier] = Record(statementIdentifier: identifier, answer: answer)
    }


    func answer(for identifier: Int) -> AnswerType {
        return answersByIdentifier[identifier]?.answer ?? .unknown
    }


    func enumerateAnswers(_ block: (Int, AnswerType) -> Void) {
        answersByIdentifier.forEach { (identifier, record) in
            if record.answer != .unknown {
                block(identifier, record.answer)
            }
        }
    }
}


extension TestAnswers {
    fileprivate struct Record {
        let statementIdentifier: Int
        let answer: AnswerType
    }
}
