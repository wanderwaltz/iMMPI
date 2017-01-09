import XCTest
@testable import iMMPI

final class TestRecordsGroupTests_Single: XCTestCase {
    let record = TestRecord(
        person: Person(
            name: "Jane Doe",
            gender: .female,
            ageGroup: .teen
        ),
        testAnswers: TestAnswers(),
        date: Date()
    )


    var group: TestRecordsGroup!


    override func setUp() {
        group = TestRecordsGroup(single: record)
    }


    func testThat__group_title_is_equal_to_person_name() {
        XCTAssertEqual(group.title, record.personName)
    }


    func testThat__group_has_a_single_record() {
        XCTAssertEqual(group.records.allItems.count, 1)
    }


    func testThat__group_contains_the_same_record_instance() {
        XCTAssertTrue(group.records.allItems.first! === record)
    }


    func testThat__group_has_a_single_section() {
        XCTAssertEqual(group.records.sections.count, 1)
    }


    func testThat__group_section_title_is_person_name() {
        XCTAssertEqual(group.records.sections.first!.title, record.personName)
    }


    func testThat__group_section_contains_a_single_record() {
        XCTAssertEqual(group.records.sections.first!.items.count, 1)
    }


    func testThet__group_section_contains_the_same_record_instance() {
        XCTAssertTrue(group.records.sections.first!.items.first! === record)
    }
}
