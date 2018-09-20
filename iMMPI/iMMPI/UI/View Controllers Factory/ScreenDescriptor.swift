import Foundation

enum ScreenDescriptor {
    case allRecords
    case trash
    case addRecord(Record)
    case editRecord(RecordIdentifier)
    case detailsForSingleRecord(RecordIdentifier)
    case detailsForMultipleRecords([RecordIdentifier])
    case analysis([RecordIdentifier])
    case answersInput(RecordIdentifier)
    case answersReview(RecordIdentifier)
    case analysisOptions(AnalysisMenuActionContext)
    case analysisReportsList(AnalysisMenuActionContext)
    case mailComposer(EmailMessage)
}
