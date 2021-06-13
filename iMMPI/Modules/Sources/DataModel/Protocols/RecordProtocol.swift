import Foundation

/// Encapsulates information about a single test session.
///
/// Test session consists of a person taking test, his/her answers for the test and the date of the test session.
public protocol RecordProtocol: AnyObject, DateConvertible, PersonNameConvertible {
    /// Person who took the test
    var person: Person { get set }

    /// Answers of the person
    var answers: Answers { get set }

    /// Date of the test session
    var date: Date { get set }
}

extension RecordProtocol {
    public func makeCopy() -> Record {
        return Record(
            person: person,
            answers: answers,
            date: date
        )
    }
}

public protocol DateConvertible {
    var date: Date { get }
}

public protocol PersonNameConvertible {
    var personName: String { get }
}
