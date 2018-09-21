import XCTest
@testable import iMMPI

final class StubRecordStorage {
    init(records: [Record] = []) {
        records.forEach({ try! store($0) })
    }

    private var storedRecords: [RecordIdentifier: Record] = [:]
}


extension StubRecordStorage: RecordStorage {
    var all: [Record] {
        return Array(storedRecords.values).sorted(by: { r1, r2 in
            if r1.person.name == r2.person.name {
                return r1.date > r2.date
            }
            else {
                return r1.person.name < r2.person.name
            }
        })
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
    static let `default`: StubRecordStorage = {
        let storage = StubRecordStorage(
            records: [
                Record(
                    person: Person(
                        name: "John Appleseed",
                        gender: .male,
                        ageGroup: .adult
                    ),
                    answers: Answers(),
                    date: Date(
                        timeIntervalSince1970: 0
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
                        timeIntervalSince1970: 0
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
                        timeIntervalSince1970: 3600 * 24 + 1
                    )
                ),
                ]
        )

        assert(storage.all.count == 3)
        return storage
    }()

    static let trash: StubRecordStorage = {
        let storage = StubRecordStorage(
            records: [
                Record(
                    person: Person(
                        name: "Chandler Bing",
                        gender: .male,
                        ageGroup: .adult
                    ),
                    answers: Answers(),
                    date: Date(
                        timeIntervalSince1970: 101112
                    )
                ),
                ]
        )

        assert(storage.all.count == 1)
        return storage
    }()
}
