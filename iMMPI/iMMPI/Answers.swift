import Foundation

final class Answers: NSObject {
    override init() {
        super.init()
    }

    fileprivate var answersByIdentifier: [Int:Record] = [:]
}


extension Answers {
    /// Determines whether this test answers object contains all answers for a certain questionnaire.
    var allStatementsAnswered: Bool {
        // TODO: think of a better way to check this
        return answersByIdentifier.count == 566
    }


    /// Sets an `AnswerType` for a statement with a given identifier.
    ///
    /// - Parameter type: answer type (agree, disagree, undefined - see source for the exact enum values),
    /// - Parameter identifier: identifier of the statement to relate the answer with.
    func setAnswer(_ answer: AnswerType, for identifier: Int) {
        answersByIdentifier[identifier] = Record(statementIdentifier: identifier, answer: answer)
    }


    /// Returns answer type for statement with the provided identifier.
    ///
    /// - Parameter identifier: identifier of the statement related to the answer.
    /// - Returns: `AnswerType` for a recorded answer. If the statement has not yet been answered, returns `.unknown`.
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


    /// Enumerates all answers with type != `.unknown`.
    ///
    /// Ordering of the enumerating answers is undefined.
    ///
    /// - Parameter block: Block to be called on each answer/statement identifier pair where answer != `.unknown`.
    func setAnswers(positive: [Statement.Identifier], negative: [Statement.Identifier]) {
        for identifier in positive {
            setAnswer(.positive, for: identifier)
        }

        for identifier in negative {
            setAnswer(.negative, for: identifier)
        }
    }
}


extension Answers {
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


extension Answers {
    override var hash: Int {
        return Array(answersByIdentifier.enumerated()).map({ $1.value.hashValue }).reduce(0, ^)
    }


    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Answers else {
            return false
        }

        let thisAnswers = Array(answersByIdentifier.values.sorted { $0.statementIdentifier < $1.statementIdentifier })
        let otherAnswers = Array(other.answersByIdentifier.values.sorted { $0.statementIdentifier < $1.statementIdentifier })

        return thisAnswers == otherAnswers
    }
}


extension Answers {
    func makeCopy() -> Answers {
        let result = Answers()

        enumerateAnswers { (identifier, answer) in
            result.setAnswer(answer, for: identifier)
        }

        return result
    }
}
