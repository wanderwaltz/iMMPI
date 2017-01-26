import UIKit
@testable import iMMPI

final class StubRouter {
    var _displayAnswersReview: (TestRecordProtocol, UIViewController) -> () = Constant.void()
    var _displayAnalysisOptions: (AnalysisMenuActionContext, UIViewController) -> () = Constant.void()
}


extension StubRouter: Router {
    func displayAllRecords(sender: UIViewController) {}
    func displayTrash(sender: UIViewController) {}

    func addRecord(basedOn record: TestRecordProtocol, sender: UIViewController) {}
    func edit(_ record: TestRecordProtocol, sender: UIViewController) {}

    func displayDetails(for group: TestRecordsGroup, sender: UIViewController) {}
    func displayDetails(for record: TestRecordProtocol, sender: UIViewController) {}

    func displayAnalysis(for record: TestRecordProtocol, sender: UIViewController) {}

    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        _displayAnalysisOptions(context, sender)
    }

    func displayAnswersReview(for record: TestRecordProtocol, sender: UIViewController) {
        _displayAnswersReview(record, sender)
    }

    func displayPrintOptions(for html: Html, sender: UIViewController) {}
    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {}

    func displayMailComposer(for email: EmailMessage, sender: UIViewController) throws {}
}
