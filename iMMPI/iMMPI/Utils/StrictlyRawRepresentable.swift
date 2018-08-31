import Foundation

protocol StrictlyRawRepresentable {
    associatedtype RawValue

    var rawValue: RawValue { get }

    init(_ rawValue: RawValue)
}
