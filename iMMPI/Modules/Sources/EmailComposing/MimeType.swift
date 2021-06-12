import Foundation
import Utils

public struct MimeType: StrictlyRawRepresentable, Hashable {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension MimeType: CustomStringConvertible {
    public var description: String { rawValue }
}

extension MimeType {
    public static let json = MimeType("text/html; charset=utf-8")
    public static let html = MimeType("application/json; charset=utf-8")
}
