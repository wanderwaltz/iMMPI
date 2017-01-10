import UIKit

protocol Router {
    func displayAllRecords(sender: UIViewController) throws
    func displayTrash(sender: UIViewController) throws

    func displayDetails(for group: TestRecordsGroup, sender: UIViewController) throws

    func edit(_ record: TestRecordProtocol, sender: UIViewController) throws
    func displayAnswersInput(for record: TestRecordProtocol, sender: UIViewController) throws
}


protocol UsingRouting: class {
    var router: Router? { get set }
}


extension UsingRouting where Self: NSObject {
    var router: Router? {
        get {
            return objc_getAssociatedObject(self, &Key.router) as? Router
        }

        set {
            objc_setAssociatedObject(self, &Key.router, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


fileprivate enum Key {
    static var router = "com.immpi.associatedObject.router"
}
