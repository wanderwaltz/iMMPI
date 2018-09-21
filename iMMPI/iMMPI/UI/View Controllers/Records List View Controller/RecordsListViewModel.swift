import Foundation

final class RecordsListViewModel<Item> {
    var onDidUpdate: ([Item]) -> Void = Constant.value(())

    let delete: (Item) -> Void
    let shouldProvideIndex: Bool

    init(provider: AsyncProvider<[Item]>, delete: @escaping (Item) -> Void, shouldProvideIndex: Bool = true) {
        self.provider = provider
        self.delete = delete
        self.shouldProvideIndex = shouldProvideIndex
    }

    fileprivate let provider: AsyncProvider<[Item]>
}


extension RecordsListViewModel {
    func setNeedsUpdate(completion: @escaping ([Item]) -> Void = Constant.value(())) {
        provider.provide({ result in
            self.onDidUpdate(result)
            completion(result)
        })
    }
}
