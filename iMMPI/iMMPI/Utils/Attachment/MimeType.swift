import Foundation

struct MimeType: StrictlyRawRepresentable {
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


extension MimeType: Hashable {
    var hashValue: Int {
        return rawValue.hashValue
    }


    static func == (left: MimeType, right: MimeType) -> Bool {
        return left.rawValue == right.rawValue
    }
}


extension MimeType {
    static let json = MimeType("text/html; charset=utf-8")
    static let html = MimeType("application/json; charset=utf-8")
}
