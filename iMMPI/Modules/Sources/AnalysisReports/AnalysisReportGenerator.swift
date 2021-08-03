import Foundation
import Analysis

public protocol AnalysisReportGenerator {
    associatedtype Output

    func generate(for result: AnalysisResult) -> Output
}
