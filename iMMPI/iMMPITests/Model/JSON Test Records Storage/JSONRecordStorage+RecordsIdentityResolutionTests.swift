import XCTest
@testable import iMMPI

final class JSONRecordStorageRecordIdentityResolutionTests: XCTestCase {
    let fileManager = FileManager.default

    override func setUp() {
        super.setUp()
        makeEmptyStorageDirectory()
    }

    override func tearDown() {
        deleteStorageDirectory()
        super.tearDown()
    }

    func testThat__test_case_actually_creates_a_valid_empty_storage() {
        let storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()
        XCTAssertTrue(storage.all.isEmpty)
    }

    func testThat__after_loading_two_records_with_the_same_identifier_it_keeps_only_one_record() {
        copyRecordJsonNamed("JA1")
        copyRecordJsonNamed("JA2")
        let storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()
        XCTAssertEqual(storage.all.count, 1)
        XCTAssertEqual(storage.all.first?.person.name, "John Appleseed")
    }

    func testThat__it_uses_the_most_recent_file_when_loading_one_of_multiple_records_with_same_identifier() {
        copyRecordJsonNamed("JA1")
        copyRecordJsonNamed("JA2")

        var storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()
        XCTAssertEqual(storage.all.first?.answers.answer(for: 1), .positive)

        makeEmptyStorageDirectory()

        copyRecordJsonNamed("JA2")
        copyRecordJsonNamed("JA1")

        storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()
        XCTAssertEqual(storage.all.first?.answers.answer(for: 1), .negative)
    }

    func testThat__when_there_is_an_index__it_still_uses_the_latest_file_first() {
        copyRecordJsonNamed("JA1")
        copyRecordJsonNamed("JA2")
        copyIndexJsonNamed("JA12-index")

        var storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()
        XCTAssertEqual(storage.all.first?.answers.answer(for: 1), .positive)

        makeEmptyStorageDirectory()

        copyRecordJsonNamed("JA1")
        copyRecordJsonNamed("JA2")
        copyIndexJsonNamed("JA21-index")

        storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()
        XCTAssertEqual(storage.all.first?.answers.answer(for: 1), .positive)

        makeEmptyStorageDirectory()

        copyRecordJsonNamed("JA2")
        copyRecordJsonNamed("JA1")
        copyIndexJsonNamed("JA12-index")

        storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()
        XCTAssertEqual(storage.all.first?.answers.answer(for: 1), .negative)

        makeEmptyStorageDirectory()

        copyRecordJsonNamed("JA2")
        copyRecordJsonNamed("JA1")
        copyIndexJsonNamed("JA21-index")

        storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()
        XCTAssertEqual(storage.all.first?.answers.answer(for: 1), .negative)
    }

    func testThat__it_deletes_old_files_when_encountering_newer_files_with_the_same_record_id() {
        copyRecordJsonNamed("JA1")
        copyRecordJsonNamed("JA2")
        let storage = try! JSONRecordsStorage(directory: .test)
        try! storage.load()

        var subpaths = try! fileManager.contentsOfDirectory(
            at: JSONRecordsStorageDirectory.test.url,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants]
        )

        subpaths.removeAll(where: { $0.lastPathComponent == "index.json" })

        XCTAssertEqual(subpaths.count, 1)
    }
}


extension JSONRecordStorageRecordIdentityResolutionTests {
    private func makeEmptyStorageDirectory() {
        deleteStorageDirectory()
        try! fileManager.createDirectory(
            at: JSONRecordsStorageDirectory.test.url,
            withIntermediateDirectories: false,
            attributes: nil
        )
    }

    private func deleteStorageDirectory() {
        try? fileManager.removeItem(at: JSONRecordsStorageDirectory.test.url)
    }

    private func copyRecordJsonNamed(_ name: String) {
        let bundle = Bundle(for: JSONRecordStorageRecordIdentityResolutionTests.self)
        let url = bundle.url(forResource: name, withExtension: "json")!
        try! fileManager.copyItem(
            at: url,
            to: JSONRecordsStorageDirectory.test.url
                .appendingPathComponent("\(name).json")
        )
    }

    private func copyIndexJsonNamed(_ name: String) {
        let bundle = Bundle(for: JSONRecordStorageRecordIdentityResolutionTests.self)
        let url = bundle.url(forResource: name, withExtension: "json")!
        try! fileManager.copyItem(
            at: url,
            to: JSONRecordsStorageDirectory.test.url
                .appendingPathComponent("index.json")
        )
    }
}


extension JSONRecordsStorageDirectory {
    fileprivate static let test = JSONRecordsStorageDirectory(name: "Test Storage")
}
