import UIKit

protocol Router: class {
    func displayAllRecords(sender: UIViewController)
    func displayTrash(sender: UIViewController)

    func displayAnalysis(for record: TestRecordProtocol, sender: UIViewController)
    func displayAnswersReview(for record: TestRecordProtocol, sender: UIViewController)

    func displayDetails(for group: TestRecordsGroup, sender: UIViewController) throws

    func addRecord(basedOn record: TestRecordProtocol, sender: UIViewController) throws
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
