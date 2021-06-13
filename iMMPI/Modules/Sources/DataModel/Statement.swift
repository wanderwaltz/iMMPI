import Foundation

/// A single statement of the questionnaire.
public struct Statement {
    /// Identifier of a statement in the questionnaire
    public typealias Identifier = Int

    /// Identifier of the statement.
    ///
    /// `identifier` is used when analyzing test results and querying an answer from `Answers` object.
    public let identifier: Identifier

    /// Text of the statement.
    public let text: String

    public init(identifier: Int, text: String) {
        self.identifier = identifier
        self.text = text
    }
}


extension Statement: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    /// `Statement` text is assumed to be only for UI,
    /// statements with the same identifier are considered identical.
    public static func == (left: Statement, right: Statement) -> Bool {
        return left.identifier == right.identifier
    }
}
