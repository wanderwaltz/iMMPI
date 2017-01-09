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


    func testThat__group_record_is_the_provided_record() {
        XCTAssertTrue(group.record === record)
    }


    func testThat__group_has_empty_grouping() {
        XCTAssertTrue(group.group.isEmpty)
    }
}
