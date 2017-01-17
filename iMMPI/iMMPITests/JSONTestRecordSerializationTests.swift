import XCTest
@testable import iMMPI

final class JSONTestRecordSerializationTests: XCTestCase {
    func testThat__json_serialization_properly_loads_records() {
        let first = loadSample(at: 3)
        let second = loadSample(at: 4)

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .none
        formatter.dateFormat = "dd-MM-yyyy"

        XCTAssertEqual(first.personName, "Test Subject 003")
        XCTAssertEqual(first.person.gender, .female)
        XCTAssertEqual(first.person.ageGroup, .teen)
        XCTAssertEqual(first.date, formatter.date(from: "05-02-2014"))

        XCTAssertEqual(second.personName, "Test Subject 004")
        XCTAssertEqual(second.person.gender, .male)
        XCTAssertEqual(second.person.ageGroup, .adult)
        XCTAssertEqual(second.date, formatter.date(from: "25-12-2013"))
    }


    func testThat__json_serialization_is_bidirectional() {
        let record = loadSample(at: 3)

        let data = JSONTestRecordSerialization.data(withTestRecord: record)!
        let restoredRecord = JSONTestRecordSerialization.testRecord(from: data)!


        XCTAssertEqual(record.personName, restoredRecord.personName)
        XCTAssertEqual(record.person.name, restoredRecord.person.name)
        XCTAssertEqual(record.person.gender, restoredRecord.person.gender)
        XCTAssertEqual(record.person.ageGroup, restoredRecord.person.ageGroup)
        XCTAssertEqual(record.date, restoredRecord.date)

        for i in 0..<566 {
            XCTAssertEqual(record.testAnswers.answer(for: i), restoredRecord.testAnswers.answer(for: i))
        }
    }


    private func loadSample(at index: Int) -> TestRecordProtocol {
        let answersFileName = String(format: "Test Subject 00%.3d", index)
        let answersFileUrl = Bundle(for: type(of: self)).url(forResource: answersFileName, withExtension: "json")!
        let answersData = try! Data(contentsOf: answersFileUrl)

        return JSONTestRecordSerialization.testRecord(from: answersData)!
    }
}
