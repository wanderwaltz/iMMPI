import Foundation

protocol AnalysisReportGenerator {
    associatedtype Output

    var title: String { get }
    func generate(for record: TestRecordProtocol, with scales: [BoundScale]) -> Output
}
