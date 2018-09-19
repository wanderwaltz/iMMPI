import Foundation

/// Encapsulates a persistent storage for objects conforming to RecordProtocol.
protocol RecordStorage: class {
    /// Return all test records currently loaded.
    var all: [RecordProtocol] { get }

    /// Store a record.
    ///
    /// - Param record: a `RecordProtocol` object to be stored in the persistent storage.
    func store(_ record: RecordProtocol) throws

    /// Remove the existing record from the storage.
    ///
    /// If the record does not yet exist in storage, this method should do nothing.
    ///
    /// - Parameter identifier: identifier of the record to remove.
    func removeRecord(with identifier: RecordIdentifier) throws

    /// Load all `RecordProtocol` objects stored in the persistent storage.
    func load() throws
}


extension RecordStorage {
    var isEmpty: Bool {
        return all.isEmpty
    }
}

extension RecordStorage {
    func makeViewModel(includeRecord: @escaping (RecordProtocol) -> Bool = Constant.value(true))
        -> RecordsListViewModel<RecordProtocol> {
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
