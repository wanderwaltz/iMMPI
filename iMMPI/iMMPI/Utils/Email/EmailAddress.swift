import Foundation

struct EmailAddress: Hashable, StrictlyRawRepresentable {
    let rawValue: String

    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}


extension EmailAddress: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}
