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

    func test__equality_of_RecordIdentifier_instances_with_close_dates() {
        let id1 = RecordIdentifier(
            personIdentifier: PersonIdentifier(
                name: "Leslie Knope"
            ),
            date: Date(
                timeIntervalSince1970: 456
            )
        )

        let id2 = RecordIdentifier(
            personIdentifier: PersonIdentifier(
                name: "Leslie Knope"
            ),
            date: Date(
                timeIntervalSince1970: 789
            )
        )

        XCTAssertEqual(
            id1,
            id2,
            """
            identifiers should be considered equal since their dates \
            have the same representation in rawValue
            """
        )
    }

    func test__non_equality_of_RecordIdentifier_instances_with_distant_dates() {
        let id1 = RecordIdentifier(
            personIdentifier: PersonIdentifier(
                name: "Leslie Knope"
            ),
            date: Date(
                timeIntervalSince1970: 456
            )
        )

        let id2 = RecordIdentifier(
            personIdentifier: PersonIdentifier(
                name: "Leslie Knope"
            ),
            date: Date(
                timeIntervalSince1970: 456 + 3600 * 24 + 1
            )
        )

        XCTAssertNotEqual(
            id1,
            id2,
            """
            identifiers should not be equal since their dates \
            have different representation in rawValue
            """
        )
    }
}
