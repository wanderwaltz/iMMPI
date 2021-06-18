import UIKit
import EmailComposing
import DataModel
import Analysis
import HTMLComposing
import Utils
import MMPIRouting

public final class StubRouter {
    public var _displayAnswersReview: (RecordProtocol, UIViewController) -> () = Constant.value(())
    public var _displayAnalysisOptions: (AnalysisMenuActionContext, UIViewController) -> () = Constant.value(())

    public init() {}
}


extension StubRouter: Router {
    public func displayAllRecords(sender: UIViewController) {}
    public func displayTrash(sender: UIViewController) {}

    public func addRecord(basedOn record: RecordProtocol, sender: UIViewController) {}
    public func edit(_ record: RecordProtocol, sender: UIViewController) {}

    public func displayDetails(for group: RecordsGroup, sender: UIViewController) {}
    public func displayDetails(for record: RecordProtocol, sender: UIViewController) {}

    public func displayAnalysis(for record: RecordProtocol, sender: UIViewController) {}

    public func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        _displayAnalysisOptions(context, sender)
    }

    public func displayDetails(
        for record: RecordProtocol,
        scale: AnalysisScale,
        sender: UIViewController
    ) {}

    public func displayAnalysis(for records: [RecordProtocol], sender: UIViewController) {}

    public func displayAnswersReview(for record: RecordProtocol, sender: UIViewController) {
        _displayAnswersReview(record, sender)
    }

    public func displayPrintOptions(for html: Html, sender: UIViewController) {}
    public func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {}

    public func displayMailComposer(for email: EmailMessage, sender: UIViewController) throws {}
}
