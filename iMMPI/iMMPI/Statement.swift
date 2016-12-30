import Foundation

/// A concrete implementation of `StatementProtocol`.
final class Statement: NSObject {
    let statementID: Int
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


extension Statement: StatementProtocol {}


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
