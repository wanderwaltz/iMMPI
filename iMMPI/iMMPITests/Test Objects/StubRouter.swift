import UIKit
@testable import iMMPI

final class StubRouter {
    enum Event: Equatable {
        case displayAllRecords
        case displayTrash
        case addRecord
        case editRecord
        case displayDetails
        case displayAnalysis
        case displayAnalysisOptions
        case displayAnswersReview
        case displayPrintOptions
        case selectAnalysisReportForPrinting
        case displayMailComposer
    }

    var receivedEvents: [Event] = []

    var _displayTrash: (UIViewController) -> Void = Constant.value(())
    var _editRecord: (RecordIdentifier, UIViewController) -> Void = Constant.value(())
    var _displayDetails: ([RecordIdentifier], UIViewController) -> Void = Constant.value(())
    var _displayAnswersReview: (RecordIdentifier, UIViewController) -> Void = Constant.value(())
    var _displayAnalysisOptions: (AnalysisMenuActionContext, UIViewController) -> Void = Constant.value(())
}


extension StubRouter: Router {
    func displayAllRecords(sender: UIViewController) {
        receivedEvents.append(.displayAllRecords)
    }

    func displayTrash(sender: UIViewController) {
        receivedEvents.append(.displayTrash)
        _displayTrash(sender)
    }

    func addRecord(basedOn record: Record, sender: UIViewController) {
        receivedEvents.append(.addRecord)
    }

    func editRecord(with identifier: RecordIdentifier, sender: UIViewController) {
        receivedEvents.append(.editRecord)
        _editRecord(identifier, sender)
    }

    func displayDetails(for records: [RecordIdentifier], sender: UIViewController) {
        receivedEvents.append(.displayDetails)
        _displayDetails(records, sender)
    }

    func displayAnalysis(for identifiers: [RecordIdentifier], sender: UIViewController) {
        receivedEvents.append(.displayAnalysis)
    }

    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        receivedEvents.append(.displayAnalysisOptions)
        _displayAnalysisOptions(context, sender)
    }

    func displayAnswersReview(for identifier: RecordIdentifier, sender: UIViewController) {
        receivedEvents.append(.displayAnswersReview)
        _displayAnswersReview(identifier, sender)
    }

    func displayPrintOptions(for html: Html, sender: UIViewController) {
        receivedEvents.append(.displayPrintOptions)
    }

    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {
        receivedEvents.append(.selectAnalysisReportForPrinting)
    }

    func displayMailComposer(for email: EmailMessage, sender: UIViewController) {
        receivedEvents.append(.displayMailComposer)
    }
}
