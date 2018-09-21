import XCTest
@testable import iMMPI

// MARK: - RecordsGroup with a single record
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
        XCTAssertTrue(group.primaryRecord.identifier == record.identifier)
    }

    func testThat__group_containsSingleRecord_returns_true() {
        XCTAssertTrue(group.containsSingleRecord)
    }

    func testThat__it_returns_its_person_name() {
        XCTAssertEqual(group.personName, group.primaryRecord.indexItem.personName)
    }

    func testThat__its_allRecords_property_returns_an_array_with_a_single_record() {
        XCTAssertEqual(group.allRecords.count, 1)
    }
}


// MARK: - RecordsGroup initialized with Grouping<Record> tests
final class RecordsGroupTests_FromGroupingOfRecord: XCTestCase {
    let grouping = groupByEqualName(StubRecordStorage.default.all)

    var group: RecordsGroup!

    override func setUp() {
        group = RecordsGroup(grouping)
    }

    func testThat__group_containsSingleRecord_returns_false() {
        XCTAssertFalse(group.containsSingleRecord)
    }

    func testThat__group_allRecords_returns_the_same_number_of_records_as_in_original_grouping() {
        XCTAssertEqual(group.allRecords.count, grouping.allItems.count)
    }
}
