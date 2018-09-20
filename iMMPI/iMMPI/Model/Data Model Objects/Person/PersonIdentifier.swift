import Foundation

struct PersonIdentifier: Hashable {
    // `Person` instances are identified by name only because otherwise it would not be possible
    // to extract a `PersonIdentifier` from a `RecordProxy` without materializing it. It is actually
    // an implementation detail and may be changed later, but for now it seems to be enough.
    init(name: String) {
        self.name = name
    }

    private let name: String
}


extension PersonIdentifier: RawRepresentable {
    var rawValue: String {
        return name
    }

    init?(rawValue: String) {
        self.init(name: rawValue)
    }
}
