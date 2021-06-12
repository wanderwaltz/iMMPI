import Foundation
import Utils

struct EmailAddress: StrictlyRawRepresentable, Hashable {
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
