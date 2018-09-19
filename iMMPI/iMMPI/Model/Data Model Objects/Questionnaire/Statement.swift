import Foundation

/// A single statement of the questionnaire.
struct Statement {
    /// Identifier of a statement in the questionnaire
    typealias Identifier = Int

    /// Identifier of the statement.
    ///
    /// `identifier` is used when analyzing test results and querying an answer from `Answers` object.
    let identifier: Identifier

    /// Text of the statement.
    let text: String

    init(identifier: Int, text: String) {
        self.identifier = identifier
        self.text = text
    }
}


extension Statement: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    /// `Statement` text is assumed to be only for UI,
    /// statements with the same identifier are considered identical.
    static func == (left: Statement, right: Statement) -> Bool {
        return left.identifier == right.identifier
    }
}
