import Foundation

struct AsyncProvider<Data> {
    typealias Completion = (Data) -> ()

    var provide: (@escaping Completion) -> ()

    init(_ provide: @escaping (@escaping Completion) -> ()) {
        self.provide = provide
    }
}


extension AsyncProvider {
    init(constant data: Data) {
        self.init({ $0(data) })
    }
}
