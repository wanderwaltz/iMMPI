import Foundation

final class ListViewModel<Item> {
    var onDidUpdate: ([Item]) -> () = Constant.void()

    let delete: (Item) -> ()
    let shouldProvideIndex: Bool

    init(provider: AsyncProvider<[Item]>, delete: @escaping (Item) -> (), shouldProvideIndex: Bool = true) {
        self.provider = provider
        self.delete = delete
        self.shouldProvideIndex = shouldProvideIndex
    }

    fileprivate let provider: AsyncProvider<[Item]>
}


extension ListViewModel {
    func setNeedsUpdate(completion: @escaping ([Item]) -> () = Constant.void()) {
        provider.provide({ result in
            self.onDidUpdate(result)
            completion(result)
        })
    }
}
