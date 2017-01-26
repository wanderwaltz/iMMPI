import Foundation

/// Identifier of a statement in the questionnaire
typealias StatementIdentifier = Int

/// A single statement of the questionnaire.
struct Statement {
    /// Identifier of the statement.
    ///
    /// `statementID` is used when analyzing test results and querying an answer from `TestAnswers` object.
    let statementID: Int

    /// Text of the statement.
    let text: String

    init(identifier: Int, text: String) {
        self.statementID = identifier
        self.text = text
    }

    init() {
        self.init(identifier: 0, text: "")
    }
}


extension Statement: Hashable {
    var hashValue: Int {
        return statementID
    }

    /// `Statement` text is assumed to be only for UI,
    /// statements with the same identifier are considered identical.
    static func == (left: Statement, right: Statement) -> Bool {
        return left.statementID == right.statementID
    }
}
