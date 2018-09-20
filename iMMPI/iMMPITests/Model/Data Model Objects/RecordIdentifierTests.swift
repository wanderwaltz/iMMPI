import XCTest
@testable import iMMPI

final class RecordIdentifierTests: XCTestCase {
    func testThat__record_identifier_can_be_initialized_with_its_raw_value() {
        let record = Record(
            person: Person(
                name: "John Appleseed",
                gender: .male,
                ageGroup: .adult
            ),
            answers: Answers(),
            date: Date(
                timeIntervalSince1970: 1234
            )
        )

        let recordIdentifier = record.identifier

        XCTAssertEqual(RecordIdentifier(rawValue: recordIdentifier.rawValue), recordIdentifier)
    }

    func testThat__record_identifier_with_invalid_raw_value_is_nil() {
        XCTAssertNil(RecordIdentifier(rawValue: "qwerty"))
        XCTAssertNil(RecordIdentifier(rawValue: "John Appleseed::qwerty"))
    }

    func testThat__last_component_is_used_for_date_parsing() {
        let recordIdentifier = RecordIdentifier(rawValue: "a::b::18-09-2018")
        let expectedRecordIdentifier = RecordIdentifier(
            personIdentifier: PersonIdentifier(
                name: "a::b"
            ),
            date: DateFormatter.serialization.date(from: "18-09-2018")!
        )

        XCTAssertEqual(recordIdentifier, expectedRecordIdentifier)
    }
}
