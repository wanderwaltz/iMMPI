import Foundation

/// Encapsulates information about a single test session.
///
/// Test session consists of a person taking test, his/her answers for the test and the date of the test session.
@objc protocol TestRecordProtocol: NSObjectProtocol {
    /// Person who took the test
    var person: PersonProtocol { get set }

    /// Shortcut for person.name
    var personName: String { get }

    /// Answers of the person
    var testAnswers: TestAnswersProtocol { get set }

    /// Date of the test session
    var date: Date { get set }
}
