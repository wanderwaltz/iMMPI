import Foundation

struct RecordIdentifier: Hashable {
    init(personIdentifier: PersonIdentifier, date: Date) {
        self.personIdentifier = personIdentifier
        self.date = date
    }

    private let personIdentifier: PersonIdentifier
    private let date: Date
}


extension RecordIdentifier: RawRepresentable {
    var rawValue: String {
        return "\(personIdentifier.rawValue)\(rawValueSeparator)\(dateFormatter.string(from: date))"
    }

    init?(rawValue: String) {
        let components = rawValue.components(separatedBy: rawValueSeparator)

        guard components.count >= 2 else {
            return nil
        }

        let dateComponent = components.last!
        let personComponent = components.dropLast().joined(separator: rawValueSeparator)

        guard let personIdentifier = PersonIdentifier(rawValue: personComponent) else {
            return nil
        }

        guard let date = dateFormatter.date(from: dateComponent) else {
            return nil
        }

        self.init(
            personIdentifier: personIdentifier,
            date: date
        )
    }
}


private let rawValueSeparator = "::"
private let dateFormatter = DateFormatter.serialization
