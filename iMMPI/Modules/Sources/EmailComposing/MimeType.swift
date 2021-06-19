import Foundation
import Utils

public struct MimeType: Hashable {
    public let rawValue: String

    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension MimeType: CustomStringConvertible {
    public var description: String { rawValue }
}

extension MimeType {
    public static let json = MimeType("text/html; charset=utf-8")
    public static let html = MimeType("application/json; charset=utf-8")

    public static let docx =
        MimeType("application/vnd.openxmlformats-officedocument.wordprocessingml.document")
}
