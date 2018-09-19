import XCTest
@testable import iMMPI

final class RecordTests: XCTestCase {
    func testThat__record_initialized_with_person_is_materialized() {
        let record = Record(
            person: Person(
                name: "John Appleseed",
                gender: .male,
                ageGroup: .adult
            ),
            answers: Answers(),
            date: Date()
        )

        XCTAssertTrue(record.isMaterialized)
    }

    func testThat__record_adopts_copy_on_write_semantics_for_person_property() {
        var record1 = Record()
        record1.person = Person(
            name: "John Appleseed",
            gender: .male,
            ageGroup: .adult
        )

        var record2 = record1
        record2.person = Person(
            name: "Ann Perkins",
            gender: .female,
            ageGroup: .adult
        )

        XCTAssertEqual(record1.person.name, "John Appleseed")
        XCTAssertEqual(record2.person.name, "Ann Perkins")
    }

    func testThat__record_adopts_copy_on_write_semantics_for_answers_property() {
        var record1 = Record()
        record1.answers = record1.answers.settingAnswer(.positive, for: 1)

        var record2 = record1
        record2.answers = record2.answers.settingAnswer(.negative, for: 2)

        XCTAssertEqual(record1.answers.answer(for: 1), .positive)
        XCTAssertEqual(record1.answers.answer(for: 2), .unknown)

        XCTAssertEqual(record2.answers.answer(for: 1), .positive)
        XCTAssertEqual(record2.answers.answer(for: 2), .negative)
    }

    func testThat__record_adopts_copy_on_write_semantics_for_date_property() {
        var record1 = Record()
        record1.date = .distantFuture

        var record2 = record1
        record2.date = .distantPast

        XCTAssertEqual(record1.date, .distantFuture)
        XCTAssertEqual(record2.date, .distantPast)
    }
}
