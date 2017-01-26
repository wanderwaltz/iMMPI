import Foundation

extension RecordStorage {
    var isEmpty: Bool {
        return all().isEmpty
    }
}

extension RecordStorage {
    func makeViewModel(includeRecord: @escaping (RecordProtocol) -> Bool = Constant.bool(true))
        -> RecordsListViewModel<RecordProtocol> {
            return RecordsListViewModel(
                provider: AsyncProvider({ completion in
                    let startTimestamp = Date()
                    DispatchQueue.global().async {
                        if self.isEmpty {
                            self.load()
                        }

                        let records = self.all().filter(includeRecord)

                        DispatchQueue.main.async {
                            let endTimestamp = Date()
                            NSLog("Loaded \(records.count) records in \(endTimestamp.timeIntervalSince(startTimestamp)/1000.0) seconds")
                            completion(records)
                        }
                    }
                }),
                delete: { item in
                    self.remove(item)
            })
    }
}
