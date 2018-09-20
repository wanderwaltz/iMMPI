import UIKit
@testable import iMMPI

final class StubRouter {
    var _displayAnswersReview: (RecordIdentifier, UIViewController) -> () = Constant.value(())
    var _displayAnalysisOptions: (AnalysisMenuActionContext, UIViewController) -> () = Constant.value(())
}


extension StubRouter: Router {
    func displayAllRecords(sender: UIViewController) {}
    func displayTrash(sender: UIViewController) {}

    func addRecord(basedOn record: Record, sender: UIViewController) {}
    func editRecord(with identifier: RecordIdentifier, sender: UIViewController) {}

    func displayDetails(for records: [RecordIdentifier], sender: UIViewController) {}

    func displayAnalysis(for identifiers: [RecordIdentifier], sender: UIViewController) {}

    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        _displayAnalysisOptions(context, sender)
    }

    func displayAnswersReview(for identifier: RecordIdentifier, sender: UIViewController) {
        _displayAnswersReview(identifier, sender)
    }

    func displayPrintOptions(for html: Html, sender: UIViewController) {}
    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {}

    func displayMailComposer(for email: EmailMessage, sender: UIViewController) {}
}
