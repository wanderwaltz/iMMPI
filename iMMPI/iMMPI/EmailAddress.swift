import Foundation

struct EmailAddress {
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


extension EmailAddress: Hashable {
    var hashValue: Int {
        return rawValue.hashValue
    }


    static func == (left: EmailAddress, right: EmailAddress) -> Bool {
        return left.rawValue == right.rawValue
    }
}
