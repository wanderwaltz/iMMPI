import Foundation

final class TestAnswers: NSObject {
    override init() {
        super.init()
    }

    fileprivate var answersByIdentifier: [Int:Record] = [:]
}


extension TestAnswers: TestAnswersProtocol {
    var allStatementsAnswered: Bool {
        // TODO: think of a better way to check this
        return answersByIdentifier.count == 566
    }


    func setAnswer(_ answer: AnswerType, for identifier: Int) {
        answersByIdentifier[identifier] = Record(statementIdentifier: identifier, answer: answer)
    }


    func answer(for identifier: Int) -> AnswerType {
        return answersByIdentifier[identifier]?.answer ?? .unknown
    }


    func enumerateAnswers(with block: (Int, AnswerType) -> Void) {
        answersByIdentifier.forEach { (identifier, record) in
            if record.answer != .unknown {
                block(identifier, record.answer)
            }
        }
    }


    func setAnswers(positive: [StatementIdentifier], negative: [StatementIdentifier]) {
        for identifier in positive {
            setAnswer(.positive, for: identifier)
        }

        for identifier in negative {
            setAnswer(.negative, for: identifier)
        }
    }
}


extension TestAnswers {
    fileprivate struct Record: Hashable {
        let statementIdentifier: Int
        let answer: AnswerType

        fileprivate var hashValue: Int {
            return statementIdentifier ^ answer.rawValue
        }


        fileprivate static func == (left: Record, right: Record) -> Bool {
            return left.statementIdentifier == right.statementIdentifier
                && left.answer == right.answer
        }
    }
}


extension TestAnswers {
    override var hash: Int {
        return Array(answersByIdentifier.enumerated()).map({ $1.value.hashValue }).reduce(0, ^)
    }


    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? TestAnswers else {
            return false
        }

        let thisAnswers = Array(answersByIdentifier.values.sorted { $0.statementIdentifier < $1.statementIdentifier })
        let otherAnswers = Array(other.answersByIdentifier.values.sorted { $0.statementIdentifier < $1.statementIdentifier })

        return thisAnswers == otherAnswers
    }
}
