import Foundation

/// Encapsulates information about a single test session.
///
/// Test session consists of a person taking test, his/her answers for the test and the date of the test session.
@objc protocol TestRecordProtocol: NSObjectProtocol, DateConvertible, PersonNameConvertible {
    /// Person who took the test
    var person: Person { get set }

    /// Answers of the person
    var testAnswers: TestAnswers { get set }

    /// Date of the test session
    var date: Date { get set }
}


extension TestRecordProtocol {
    func makeCopy() -> TestRecord {
        return TestRecord(
            person: person.makeCopy(),
            testAnswers: testAnswers.makeCopy(),
            date: date
        )
    }
}


@objc protocol DateConvertible {
    var date: Date { get }
}


@objc protocol PersonNameConvertible {
    var personName: String { get }
}
