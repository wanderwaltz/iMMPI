import UIKit

protocol Router: class {
    func displayAllRecords(sender: UIViewController)
    func displayTrash(sender: UIViewController)

    func addRecord(basedOn record: Record, sender: UIViewController)
    func edit(_ record: Record, sender: UIViewController)

    func displayDetails(for records: [RecordIdentifier], sender: UIViewController)

    func displayAnalysis(for records: [Record], sender: UIViewController)
    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController)

    func displayAnswersReview(for record: Record, sender: UIViewController)

    func displayPrintOptions(for html: Html, sender: UIViewController)
    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController)

    func displayMailComposer(for email: EmailMessage, sender: UIViewController) throws
}


/// A protocol for objects having a `router` property.
///
/// With default implementation of the protocol for `NSObject` subclasses,
/// this protocol can be used as a mixin for easy adding of routing functionality
/// to view controllers.
protocol UsingRouting: class {
    /// `Router` contained in a `UsingRouting` instance.
    var router: Router? { get set }
}


/// Default implementation of `UsingRouting` for `NSObject` subclasses.
///
/// Uses associated objects for storage.
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
