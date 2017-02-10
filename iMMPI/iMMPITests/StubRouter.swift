import UIKit
@testable import iMMPI

final class StubRouter {
    var _displayAnswersReview: (RecordProtocol, UIViewController) -> () = Constant.value(())
    var _displayAnalysisOptions: (AnalysisMenuActionContext, UIViewController) -> () = Constant.value(())
}


extension StubRouter: Router {
    func displayAllRecords(sender: UIViewController) {}
    func displayTrash(sender: UIViewController) {}

    func addRecord(basedOn record: RecordProtocol, sender: UIViewController) {}
    func edit(_ record: RecordProtocol, sender: UIViewController) {}

    func displayDetails(for group: RecordsGroup, sender: UIViewController) {}
    func displayDetails(for record: RecordProtocol, sender: UIViewController) {}

    func displayAnalysis(for record: RecordProtocol, sender: UIViewController) {}

    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        _displayAnalysisOptions(context, sender)
    }

    func displayAnalysis(for records: [RecordProtocol], sender: UIViewController) {}

    func displayAnswersReview(for record: RecordProtocol, sender: UIViewController) {
        _displayAnswersReview(record, sender)
    }

    func displayPrintOptions(for html: Html, sender: UIViewController) {}
    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {}

    func displayMailComposer(for email: EmailMessage, sender: UIViewController) throws {}
}
