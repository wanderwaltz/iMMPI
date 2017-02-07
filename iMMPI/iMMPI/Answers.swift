import Foundation

struct Answers {
    init(positive: [Statement.Identifier] = [], negative: [Statement.Identifier] = []) {
        var answersByIdentifier: [Statement.Identifier:Entry] = [:]

        for identifier in positive {
            answersByIdentifier[identifier] = Entry(statementIdentifier: identifier, answer: .positive)
        }

        for identifier in negative {
            answersByIdentifier[identifier] = Entry(statementIdentifier: identifier, answer: .negative)
        }

        self.init(answersByIdentifier: answersByIdentifier)
    }

    fileprivate init(answersByIdentifier: [Statement.Identifier:Entry]) {
        self.answersByIdentifier = answersByIdentifier
    }

    fileprivate let answersByIdentifier: [Statement.Identifier:Entry]
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
    /// - Returns: an updated `Answers` struct.
    func settingAnswer(_ answer: AnswerType, for identifier: Statement.Identifier) -> Answers {
        var answersByIdentifier = self.answersByIdentifier
        answersByIdentifier[identifier] = Entry(statementIdentifier: identifier, answer: answer)
        return Answers(answersByIdentifier: answersByIdentifier)
    }


    /// Returns answer type for statement with the provided identifier.
    ///
    /// - Parameter identifier: identifier of the statement related to the answer.
    /// - Returns: `AnswerType` for a recorded answer. If the statement has not yet been answered, returns `.unknown`.
    func answer(for identifier: Statement.Identifier) -> AnswerType {
        return answersByIdentifier[identifier]?.answer ?? .unknown
    }


    func enumerateAnswers(with block: (Statement.Identifier, AnswerType) -> Void) {
        answersByIdentifier.forEach { (identifier, entry) in
            if entry.answer != .unknown {
                block(identifier, entry.answer)
            }
        }
    }
}


extension Answers {
    fileprivate struct Entry: Hashable {
        let statementIdentifier: Statement.Identifier
        let answer: AnswerType

        fileprivate var hashValue: Int {
            return statementIdentifier.hashValue ^ answer.rawValue.hashValue
        }


        fileprivate static func == (left: Entry, right: Entry) -> Bool {
            return left.statementIdentifier == right.statementIdentifier
                && left.answer == right.answer
        }
    }
}


extension Answers: Hashable {
    var hashValue: Int {
        return Array(answersByIdentifier.enumerated()).map({ $1.value.hashValue }).reduce(0, ^)
    }


    static func == (left: Answers, right: Answers) -> Bool {
        let leftAnswers = Array(left.answersByIdentifier.values
            .sorted { $0.statementIdentifier < $1.statementIdentifier })

        let rightAnswers = Array(right.answersByIdentifier.values
            .sorted { $0.statementIdentifier < $1.statementIdentifier })

        return leftAnswers == rightAnswers
    }
}
