import Foundation

protocol AnalysisReportGenerator {
    associatedtype Output

    func generate(for record: TestRecordProtocol, with analyser: Analyzer) -> Output
}
