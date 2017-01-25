import Foundation

protocol AnalysisReportGenerator {
    associatedtype Output

    var title: String { get }
    func generate(for result: AnalysisResult) -> Output
}
