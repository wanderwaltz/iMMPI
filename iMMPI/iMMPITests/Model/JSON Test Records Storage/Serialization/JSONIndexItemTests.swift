import XCTest
@testable import iMMPI

final class JSONIndexItemTests: XCTestCase {
    func testThat__settingPersonName__sets_person_name() {
        let indexItem = JSONIndexItem(
            personName: "John Appleseed",
            date: Date(timeIntervalSince1970: 10),
            fileName: "fileName",
            directory: .init(name: "directory")
        )

        XCTAssertEqual(indexItem.settingPersonName("Daniel Melon").personName, "Daniel Melon")
    }


    func testThat__settingPersonName__keeps_all_other_properties_unchanged() {
        let indexItem = JSONIndexItem(
            personName: "John Appleseed",
            date: Date(timeIntervalSince1970: 10),
            fileName: "fileName",
            directory: .init(name: "directory")
        )

        XCTAssertEqual(indexItem.settingPersonName("Daniel Melon").date, indexItem.date)
        XCTAssertEqual(indexItem.settingPersonName("Daniel Melon").fileName, indexItem.fileName)
        XCTAssertEqual(indexItem.settingPersonName("Daniel Melon").directory, indexItem.directory)
    }


    func testThat__settingDate__sets_date() {
        let indexItem = JSONIndexItem(
            personName: "John Appleseed",
            date: Date(timeIntervalSince1970: 10),
            fileName: "fileName",
            directory: .init(name: "directory")
        )

        let newDate = Date(timeIntervalSince1970: 123)

        XCTAssertEqual(indexItem.settingDate(newDate).date, newDate)
    }


    func testThat__settingDate__keeps_all_other_properties_unchanged() {
        let indexItem = JSONIndexItem(
            personName: "John Appleseed",
            date: Date(timeIntervalSince1970: 10),
            fileName: "fileName",
            directory: .init(name: "directory")
        )

        let newDate = Date(timeIntervalSince1970: 123)

        XCTAssertEqual(indexItem.settingDate(newDate).personName, indexItem.personName)
        XCTAssertEqual(indexItem.settingDate(newDate).fileName, indexItem.fileName)
        XCTAssertEqual(indexItem.settingDate(newDate).directory, indexItem.directory)
    }


    func testThat__initializing_with_a_record__inherits_records_properties() {
        let record = Record(
            person: Person(name: "John Appleseed"),
            date: Date(timeIntervalSince1970: 100)
        )

        let indexItem = JSONIndexItem(
            record: record,
            fileName: "fileName",
            directory: .init(name: "directory")
        )

        XCTAssertEqual(indexItem.personName, record.personName)
        XCTAssertEqual(indexItem.date, record.date)
    }
}
