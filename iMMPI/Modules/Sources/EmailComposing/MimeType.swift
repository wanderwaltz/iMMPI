import Foundation

struct MimeType: StrictlyRawRepresentable, Hashable {
    let rawValue: String

    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}


extension MimeType: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}


extension MimeType {
    static let json = MimeType("text/html; charset=utf-8")
    static let html = MimeType("application/json; charset=utf-8")
}
