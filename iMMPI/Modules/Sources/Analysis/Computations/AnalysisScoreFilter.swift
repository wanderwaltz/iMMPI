import Foundation
import Utils

public struct AnalysisScoreFilter {
    public let isWithinNorm: (Double) -> Bool

    init(_ isWithinNorm: @escaping (Double) -> Bool) {
        self.isWithinNorm = isWithinNorm
    }
}

extension AnalysisScoreFilter {
    public static let never = AnalysisScoreFilter(Constant.value(false))
    public static let bracketed = AnalysisScoreFilter({ fabs($0 - 3.0) < 0.05 })
    public static let median = AnalysisScoreFilter({ 40.0...60.0 ~= $0 })
}
