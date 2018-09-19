import Foundation

struct RecordIdentifier: Hashable {
    init(personIdentifier: PersonIdentifier, date: Date) {
        self.personIdentifier = personIdentifier
        self.date = date
    }

    private let personIdentifier: PersonIdentifier
    private let date: Date
}
