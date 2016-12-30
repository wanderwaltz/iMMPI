import Foundation

/// A concrete implementation of `StatementProtocol`.
final class Statement: NSObject {
    var statementID = 0
    var text = ""
}


extension Statement: StatementProtocol {}
