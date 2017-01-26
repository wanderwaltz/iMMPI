import Foundation

/// Identifier of a statement in the questionnaire
typealias StatementIdentifier = Int

/// A single statement of the questionnaire.
final class Statement: NSObject {
    /// Identifier of the statement.
    ///
    /// `statementID` is used when analyzing test results and querying an answer from `TestAnswers` object.
    let statementID: Int

    /// Text of the statement.
    let text: String

    init(identifier: Int, text: String) {
        self.statementID = identifier
        self.text = text
        super.init()
    }

    convenience override init() {
        self.init(identifier: 0, text: "")
    }
}


extension Statement {
    override var hash: Int {
        return statementID
    }


    /// `Statement` text is assumed to be only for UI,
    /// statements with the same identifier are considered identical.
    override func isEqual(_ object: Any?) -> Bool {
        guard let statement = object as? Statement else {
            return false
        }

        return self.statementID == statement.statementID
    }
}
