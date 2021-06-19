import UIKit
import EmailComposing
import DataModel
import Analysis
import HTMLComposing

public protocol Router: AnyObject {
    func displayAllRecords(sender: UIViewController)
    func displayTrash(sender: UIViewController)

    func addRecord(basedOn record: RecordProtocol, sender: UIViewController)
    func edit(_ record: RecordProtocol, sender: UIViewController)

    func displayDetails(for group: RecordsGroup, sender: UIViewController)
    func displayDetails(for record: RecordProtocol, sender: UIViewController)

    func displayAnalysis(for records: [RecordProtocol], sender: UIViewController)
    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController)
    
    func displayDetails(
        for record: RecordProtocol,
        scale: AnalysisScale,
        sender: UIViewController
    )

    func displayAnswersReview(for record: RecordProtocol, sender: UIViewController)

    func displayPrintOptions(for html: Html, sender: UIViewController)
    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController)

    func displayMailComposer(for email: EmailMessage, sender: UIViewController) throws

    func displayShareSheet(for attachments: [Attachment], sender: UIViewController) throws
}


/// A protocol for objects having a `router` property.
///
/// With default implementation of the protocol for `NSObject` subclasses,
/// this protocol can be used as a mixin for easy adding of routing functionality
/// to view controllers.
public protocol UsingRouting: AnyObject {
    /// `Router` contained in a `UsingRouting` instance.
    var router: Router? { get set }
}


/// Default implementation of `UsingRouting` for `NSObject` subclasses.
///
/// Uses associated objects for storage.
extension UsingRouting where Self: NSObject {
    public var router: Router? {
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
