import Foundation
import Utils

public struct EmailAddress: Hashable {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension EmailAddress: CustomStringConvertible {
    public var description: String { rawValue }
}
