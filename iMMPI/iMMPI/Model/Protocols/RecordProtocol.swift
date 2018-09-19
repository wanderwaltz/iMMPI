import Foundation

/// Encapsulates information about a single test session.
///
/// Test session consists of a person taking test, his/her answers for the test and the date of the test session.
protocol RecordProtocol {
    // TODO: implement it in a better way to avoid redundancy
    /// Name of the person who took the test
    var personName: String { get }

    /// Person who took the test
    var person: Person { get set }

    /// Answers of the person
    var answers: Answers { get set }

    /// Date of the test session
    var date: Date { get set }
}


extension RecordProtocol {
    var identifier: RecordIdentifier {
        return RecordIdentifier(
            personIdentifier: PersonIdentifier(
                name: personName
            ),
            date: date
        )
    }
}
