import UIKit

struct ViewControllerMaker {
    typealias Context = ViewControllerFactoryContext

    init(_ make: @escaping (Context) -> UIViewController) {
        _make = make
    }

    private let _make: (Context) -> UIViewController
}


extension ViewControllerMaker {
    func make(with context: Context) -> UIViewController {
        return _make(context)
    }
}
