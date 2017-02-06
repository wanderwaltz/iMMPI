import Foundation

/// A concrete implementation of RecordProtocol.
///
/// Initializing this class instance with -init method will also create a `Person` object and
/// set it as the person property value. `testAnswers` property will be initialized with empty
/// `Answers` object; date property defaults to the current date/time.
final class Record {
    var person: Person
    var testAnswers: Answers
    var date: Date

    init(person: Person = Person(), testAnswers: Answers = Answers(), date: Date = Date()) {
        self.person = person
        self.testAnswers = testAnswers
        self.date = date
    }
}


extension Record: RecordProtocol {
    public var personName: String {
        return person.name
    }
}
