@testable import iMMPI

final class StubRouter: Router {
    func displayAllRecords(sender: UIViewController) {}
    func displayTrash(sender: UIViewController) {}

    func displayAnalysis(for record: TestRecordProtocol, sender: UIViewController) {}
    func displayAnswersReview(for record: TestRecordProtocol, sender: UIViewController) {}

    func displayDetails(for group: TestRecordsGroup, sender: UIViewController) throws {}

    func addRecord(basedOn record: TestRecordProtocol, sender: UIViewController) throws {}
    func edit(_ record: TestRecordProtocol, sender: UIViewController) throws {}
    func displayAnswersInput(for record: TestRecordProtocol, sender: UIViewController) throws {}

    func displayAnalysisOptions(sender: UIViewController, origin: UIBarButtonItem) throws {}
}
