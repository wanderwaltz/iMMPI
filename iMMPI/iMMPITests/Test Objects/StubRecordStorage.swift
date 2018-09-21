import Foundation
@testable import iMMPI

final class StubRecordStorage {
    init(records: [Record] = []) {
        records.forEach({ try! store($0) })
    }

    private var storedRecords: [RecordIdentifier: Record] = [:]
}


extension StubRecordStorage: RecordStorage {
    var all: [Record] {
        return Array(storedRecords.values)
    }

    func store(_ record: Record) throws {
        storedRecords[record.identifier] = record
    }

    func removeRecord(with identifier: RecordIdentifier) throws {
        storedRecords.removeValue(forKey: identifier)
    }

    func load() throws {
        // does nothing; already loaded
    }
}


extension StubRecordStorage {
    static let `default` = StubRecordStorage(
        records: [
            Record(
                person: Person(
                    name: "John Appleseed",
                    gender: .male,
                    ageGroup: .adult
                ),
                answers: Answers(),
                date: Date(
                    timeIntervalSince1970: 123
                )
            ),

            Record(
                person: Person(
                    name: "Leslie Knope",
                    gender: .female,
                    ageGroup: .adult
                ),
                answers: Answers(),
                date: Date(
                    timeIntervalSince1970: 456
                )
            ),
        ]
    )

    static let trash = StubRecordStorage(
        records: [
            Record(
                person: Person(
                    name: "Chandler Bing",
                    gender: .male,
                    ageGroup: .adult
                ),
                answers: Answers(),
                date: Date(
                    timeIntervalSince1970: 789
                )
            ),
        ]
    )
}
