import Foundation

/// A concrete implementation of RecordProtocol.
///
/// Initializing this class instance with -init method will also create a `Person` object and
/// set it as the person property value. `answers` property will be initialized with empty
/// `Answers` object; date property defaults to the current date/time.
public final class Record {
    public var person: Person
    public var answers: Answers
    public var date: Date

    public init(
        person: Person = Person(),
        answers: Answers = Answers(),
        date: Date = Date()
    ) {
        self.person = person
        self.answers = answers
        self.date = date
    }
}

extension Record: RecordProtocol {
    public var personName: String {
        return person.name
    }
}
