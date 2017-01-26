import Foundation

/// A concrete implementation of TestRecordProtocol.
///
/// Initializing this class instance with -init method will also create a `Person` object and
/// set it as the person property value. `testAnswers` property will be initialized with empty
/// `TestAnswers` object; date property defaults to the current date/time.
final class TestRecord: NSObject {
    var person: PersonProtocol
    var testAnswers: TestAnswers
    var date: Date

    init(person: PersonProtocol, testAnswers: TestAnswers, date: Date) {
        self.person = person
        self.testAnswers = testAnswers
        self.date = date
        super.init()
    }

    convenience override init() {
        self.init(person: Person(), testAnswers: TestAnswers(), date: Date())
    }
}


extension TestRecord: TestRecordProtocol {
    public var personName: String {
        return person.name
    }
}
