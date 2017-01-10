import Foundation

extension TestRecordStorage {
    var isEmpty: Bool {
        return all().isEmpty
    }
}

extension TestRecordStorage {
    func makeViewModel(includeRecord: @escaping (TestRecordProtocol) -> Bool = Constant.bool(true))
        -> ListViewModel<TestRecordProtocol> {
            return ListViewModel(
                provider: AsyncProvider({ completion in
                    DispatchQueue.global().async {
                        if self.isEmpty {
                            self.load()
                        }

                        let records = self.all().filter(includeRecord)

                        DispatchQueue.main.async {
                            completion(records)
                        }
                    }
                }),
                delete: { item in
                    self.remove(item)
            })
    }
}
