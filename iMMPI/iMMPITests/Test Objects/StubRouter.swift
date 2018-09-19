import UIKit
@testable import iMMPI

final class StubRouter {
    var _displayAnswersReview: (Record, UIViewController) -> () = Constant.value(())
    var _displayAnalysisOptions: (AnalysisMenuActionContext, UIViewController) -> () = Constant.value(())
}


extension StubRouter: Router {
    func displayAllRecords(sender: UIViewController) {}
    func displayTrash(sender: UIViewController) {}

    func addRecord(basedOn record: Record, sender: UIViewController) {}
    func edit(_ record: Record, sender: UIViewController) {}

    func displayDetails(for records: [RecordIdentifier], sender: UIViewController) {}

    func displayAnalysis(for record: Record, sender: UIViewController) {}

    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        _displayAnalysisOptions(context, sender)
    }

    func displayAnalysis(for records: [Record], sender: UIViewController) {}

    func displayAnswersReview(for record: Record, sender: UIViewController) {
        _displayAnswersReview(record, sender)
    }

    func displayPrintOptions(for html: Html, sender: UIViewController) {}
    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {}

    func displayMailComposer(for email: EmailMessage, sender: UIViewController) throws {}
}
