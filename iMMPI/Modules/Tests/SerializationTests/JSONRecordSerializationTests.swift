import XCTest
import Serialization
import AnalysisTestSamples

final class JSONRecordSerializationTests: XCTestCase {
    var serialization: JSONRecordSerialization!

    override func setUp() {
        super.setUp()
        serialization = JSONRecordSerialization()
    }


    func testThat__json_serialization_properly_loads_records() {
        let first = TestSamples.record(at: 3)
        let second = TestSamples.record(at: 4)

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
        let record = TestSamples.record(at: 3)

        let data = serialization.encode(record)!
        let restoredRecord = serialization.decode(data)!


        XCTAssertEqual(record.personName, restoredRecord.personName)
        XCTAssertEqual(record.person.name, restoredRecord.person.name)
        XCTAssertEqual(record.person.gender, restoredRecord.person.gender)
        XCTAssertEqual(record.person.ageGroup, restoredRecord.person.ageGroup)
        XCTAssertEqual(record.date, restoredRecord.date)

        for i in 0..<566 {
            XCTAssertEqual(record.answers.answer(for: i), restoredRecord.answers.answer(for: i))
        }
    }
}
