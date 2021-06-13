import Foundation
import DataModel

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
            delete: { item in
                try? self.remove(item)
            })
    }
}
