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
