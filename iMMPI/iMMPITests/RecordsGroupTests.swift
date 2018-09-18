import XCTest
@testable import iMMPI

final class RecordsGroupTests_Single: XCTestCase {
    let record = Record(
        person: Person(
            name: "Jane Doe",
            gender: .female,
            ageGroup: .teen
        ),
        answers: Answers(),
        date: Date()
    )

    var group: RecordsGroup!

    override func setUp() {
        group = RecordsGroup(single: record)
    }

    func testThat__group_record_is_the_provided_record() {
        XCTAssertTrue(group.record === record)
    }

    func testThat__group_has_empty_grouping() {
        XCTAssertTrue(group.group.isEmpty)
    }

    func testThat__group_containsSingleRecord_returns_true() {
        XCTAssertTrue(group.containsSingleRecord)
    }

    func testThat__it_returns_its_person_name() {
        XCTAssertEqual(group.personName, group.record.personName)
    }
}
