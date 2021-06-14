import Foundation
import Utils

public final class RecordsListViewModel<Item> {
    var onDidUpdate: ([Item]) -> () = Constant.value(())

    let delete: (Item) -> ()
    let shouldProvideIndex: Bool

    init(provider: AsyncProvider<[Item]>, delete: @escaping (Item) -> (), shouldProvideIndex: Bool = true) {
        self.provider = provider
        self.delete = delete
        self.shouldProvideIndex = shouldProvideIndex
    }

    fileprivate let provider: AsyncProvider<[Item]>
}


extension RecordsListViewModel {
    func setNeedsUpdate(completion: @escaping ([Item]) -> () = Constant.value(())) {
        provider.provide({ result in
            self.onDidUpdate(result)
            completion(result)
        })
    }
}
