import Foundation

/// A single statement of the questionnaire.
@objc protocol StatementProtocol {
    /// Identifier of the statement.
    ///
    /// `statementID` is used when analyzing test results and querying an answer from `TestAnswers` object.
    var statementID: Int { get }

    /// Text of the statement.
    var text: String { get }
}
