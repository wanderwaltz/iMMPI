import Foundation

/// Encapsulates a persistent storage for objects conforming to Record.
protocol RecordStorage: class {
    /// Return all test records currently loaded.
    var all: [Record] { get }

    /// Store a record.
    ///
    /// - Param record: a `Record` object to be stored in the persistent storage.
    func store(_ record: Record) throws

    /// Remove the existing record from the storage.
    ///
    /// If the record does not yet exist in storage, this method should do nothing.
    ///
    /// - Parameter identifier: identifier of the record to remove.
    func removeRecord(with identifier: RecordIdentifier) throws

    /// Load all `Record` objects stored in the persistent storage.
    func load() throws
}


extension RecordStorage {
    var isEmpty: Bool {
        return all.isEmpty
    }
}

extension RecordStorage {
    func makeViewModel(includeRecord: @escaping (Record) -> Bool = Constant.value(true))
        -> RecordsListViewModel<Record> {
            return RecordsListViewModel(
                provider: AsyncProvider({ completion in
                    let startTimestamp = Date()
                    DispatchQueue.global().async {
                        if self.isEmpty {
                            try? self.load()
                        }

                        let records = self.all.filter(includeRecord)

                        DispatchQueue.main.async {
                            let endTimestamp = Date()
                            NSLog("Loaded \(records.count) records in \(endTimestamp.timeIntervalSince(startTimestamp)/1000.0) seconds")
                            completion(records)
                        }
                    }
                }),
                delete: { record in
                    try? self.removeRecord(with: record.identifier)
                }
            )
    }
}
