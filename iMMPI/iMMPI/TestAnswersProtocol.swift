import Foundation

@objc protocol TestAnswersProtocol {
    /// Determines whether this test answers object contains all answers for a certain questionnaire.
    var allStatementsAnswered: Bool { get }


    /// Sets an `AnswerType` for a statement with a given identifier.
    ///
    /// - Parameter type: answer type (agree, disagree, undefined - see source for the exact enum values),
    /// - Parameter identifier: identifier of the statement to relate the answer with.
    @objc(setAnswerType:forStatementID:)
    func setAnswer(_ type: AnswerType, for identifier: Int)


    /// Returns answer type for statement with the provided identifier.
    ///
    /// - Parameter identifier: identifier of the statement related to the answer.
    /// - Returns: `AnswerType` for a recorded answer. If the statement has not yet been answered, returns `.unknown`.
    @objc(answerTypeForStatementID:)
    func answer(for identifier: Int) -> AnswerType


    /// Enumerates all answers with type != `.unknown`.
    ///
    /// Ordering of the enumerating answers is undefined.
    ///
    /// Used for serialization of test records.
    ///
    /// - Parameter block: Block to be called on each answer/statement identifier pair where answer != `.unknown`.
    @objc(enumerateAnswers:)
    func enumerateAnswers(with block: (Int, AnswerType) -> ())
}
