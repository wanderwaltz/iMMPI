import Foundation

public struct Answers {
    private let answersByIdentifier: [Statement.Identifier:Entry]

    public init(
        positive: [Statement.Identifier] = [],
        negative: [Statement.Identifier] = []
    ) {
        var answersByIdentifier: [Statement.Identifier:Entry] = [:]

        for identifier in positive {
            answersByIdentifier[identifier] = Entry(statementIdentifier: identifier, answer: .positive)
        }

        for identifier in negative {
            answersByIdentifier[identifier] = Entry(statementIdentifier: identifier, answer: .negative)
        }

        self.init(answersByIdentifier: answersByIdentifier)
    }

    private init(answersByIdentifier: [Statement.Identifier:Entry]) {
        self.answersByIdentifier = answersByIdentifier
    }
}


extension Answers {
    /// Determines whether this test answers object contains all answers for a certain questionnaire.
    public func allStatementsAnswered(for questionnaire: Questionnaire) -> Bool {
        for statement in questionnaire {
            if answer(for: statement.identifier) == .unknown {
                return false
            }
        }

        return true
    }


    /// Sets an `AnswerType` for a statement with a given identifier.
    ///
    /// - Parameter type: answer type (agree, disagree, undefined - see source for the exact enum values),
    /// - Parameter identifier: identifier of the statement to relate the answer with.
    /// - Returns: an updated `Answers` struct.
    public func settingAnswer(
        _ answer: AnswerType,
        for identifier: Statement.Identifier
    ) -> Answers {
        var answersByIdentifier = self.answersByIdentifier

        answersByIdentifier[identifier] = Entry(
            statementIdentifier: identifier,
            answer: answer
        )

        return Answers(answersByIdentifier: answersByIdentifier)
    }


    /// Returns answer type for statement with the provided identifier.
    ///
    /// - Parameter identifier: identifier of the statement related to the answer.
    /// - Returns: `AnswerType` for a recorded answer. If the statement has not yet been answered, returns `.unknown`.
    public func answer(for identifier: Statement.Identifier) -> AnswerType {
        return answersByIdentifier[identifier]?.answer ?? .unknown
    }


    public func enumerateAnswers(
        with block: (Statement.Identifier, AnswerType) -> Void
    ) {
        answersByIdentifier
            .sorted(by: { $0.key < $1.key })
            .forEach { (identifier, entry) in
                if entry.answer != .unknown {
                    block(identifier, entry.answer)
                }
            }
    }
}


extension Answers {
    private struct Entry: Hashable {
        let statementIdentifier: Statement.Identifier
        let answer: AnswerType
    }
}


extension Answers: Hashable {
    public func hash(into hasher: inout Hasher) {
        for answer in answersByIdentifier.values {
            hasher.combine(answer)
        }
    }

    public static func == (left: Answers, right: Answers) -> Bool {
        let leftAnswers = Array(left.answersByIdentifier.values
            .sorted { $0.statementIdentifier < $1.statementIdentifier })

        let rightAnswers = Array(right.answersByIdentifier.values
            .sorted { $0.statementIdentifier < $1.statementIdentifier })

        return leftAnswers == rightAnswers
    }
}
