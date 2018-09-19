import XCTest
@testable import iMMPI

final class JSONRecordsStorageTests: XCTestCase {
    let fileManager = FileManager.default

    var storage: JSONRecordsStorage!

    override func setUp() {
        super.setUp()
        copyTestStorage()
        storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()
    }

    override func tearDown() {
        deleteTestStorage()
        super.tearDown()
    }

    func testThat__it_loads_records() {
        XCTAssertFalse(storage.all.isEmpty)
    }

    func testThat__records_are_parsed_as_expected() {
        let record = storage.all.first(where: { $0.identifier == .johnAppleseed_19_09 })

        XCTAssertEqual(record?.person.name, "John Appleseed")
        XCTAssertEqual(record?.person.ageGroup, .adult)
        XCTAssertEqual(record?.person.gender, .male)

        XCTAssertEqual(record?.date, DateFormatter.serialization.date(from: "19-09-2018")!)

        XCTAssertEqual(record?.answers.answer(for: 1), .positive)
        XCTAssertEqual(record?.answers.answer(for: 2), .negative)
        XCTAssertEqual(record?.answers.answer(for: 3), .positive)
    }

    func testThat__deleting_record_by_identifier_decreases_number_of_records_in_storage() {
        let countBeforeDeletingRecord = storage.all.count
        try! storage.removeRecord(with: .johnAppleseed_19_09)
        let countAfterDeletingRecord = storage.all.count
        XCTAssertEqual(countAfterDeletingRecord, countBeforeDeletingRecord - 1)
    }

    func testThat__deleting_record_actually_removes_data_from_the_file_system() {
        let countBeforeDeletingRecord = storage.all.count
        try! storage.removeRecord(with: .johnAppleseed_19_09)

        let newStorage = try! JSONRecordsStorage(directory: .test)
        try! newStorage.load()

        XCTAssertEqual(newStorage.all.count, countBeforeDeletingRecord - 1)
        XCTAssertEqual(storage.all.count, newStorage.all.count)
    }

    func testThat__all_records_in_storage_have_different_ids() {
        let ids = Set(storage.all.map({ $0.identifier }))
        XCTAssertEqual(ids.count, storage.all.count)
    }

    func testThat__storing_record_with_existing_id_does_not_add_a_new_record() {
        var record = storage.all.first(where: { $0.identifier == .johnAppleseed_19_09 })!
        record.answers = record.answers.settingAnswer(.positive, for: 5)

        let countBeforeStoringRecord = storage.all.count
        try! storage.store(record)
        let countAfterStoringRecord = storage.all.count

        XCTAssertEqual(countBeforeStoringRecord, countAfterStoringRecord)
    }

    func testThat__storing_record_with_existing_id_updates_record_in_storage() {
        var record = storage.all.first(where: { $0.identifier == .johnAppleseed_19_09 })!

        XCTAssertEqual(record.answers.answer(for: 5), .unknown)

        record.answers = record.answers.settingAnswer(.positive, for: 5)

        try! storage.store(record)

        let newRecord = storage.all.first(where: { $0.identifier == .johnAppleseed_19_09 })!

        XCTAssertEqual(newRecord.answers.answer(for: 5), .positive)
    }

    func testThat__storing_record_with_existing_id_actually_saves_record_to_file_system() {
        var record = storage.all.first(where: { $0.identifier == .johnAppleseed_19_09 })!
        record.answers = record.answers.settingAnswer(.positive, for: 5)
        try! storage.store(record)

        let newStorage = try! JSONRecordsStorage(directory: .test)
        try! newStorage.load()

        let newRecord = newStorage.all.first(where: { $0.identifier == .johnAppleseed_19_09 })!

        XCTAssertEqual(newRecord.answers.answer(for: 5), .positive)
    }

    func testThat__storing_record_with_different_id_saves_a_new_record() {
        var record = storage.all.first(where: { $0.identifier == .johnAppleseed_19_09 })!
        record.date = DateFormatter.serialization.date(from: "20-09-2018")!

        let countBeforeStoringRecord = storage.all.count
        try! storage.store(record)
        let countAfterStoringRecord = storage.all.count

        XCTAssertEqual(countAfterStoringRecord, countBeforeStoringRecord + 1)
    }
}


extension JSONRecordsStorageTests {
    private var testStorageURLInResourcesBundle: URL {
        return Bundle(for: JSONRecordsStorageTests.self).url(
            forResource: JSONRecordsStorageDirectory.test.name,
            withExtension: nil
        )!
    }

    private func copyTestStorage() {
        deleteTestStorage()
        try? fileManager.copyItem(at: testStorageURLInResourcesBundle, to: JSONRecordsStorageDirectory.test.url)
    }

    private func deleteTestStorage() {
        try? fileManager.removeItem(at: JSONRecordsStorageDirectory.test.url)
    }
}


extension RecordIdentifier {
    static let johnAppleseed_19_09 = RecordIdentifier(
        personIdentifier: PersonIdentifier(
            name: "John Appleseed"
        ),
        date: DateFormatter.serialization.date(
            from: "19-09-2018"
        )!
    )
}


extension JSONRecordsStorageDirectory {
    static let test = JSONRecordsStorageDirectory(name: "Test Storage")
}
