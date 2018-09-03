import Foundation

struct AnalysisScoreFilter {
    let isWithinNorm: (Double) -> Bool

    init(_ isWithinNorm: @escaping (Double) -> Bool) {
        self.isWithinNorm = isWithinNorm
    }
}


extension AnalysisScoreFilter {
    static let never = AnalysisScoreFilter(Constant.value(false))
    static let bracketed = AnalysisScoreFilter({ fabs($0 - 3.0) < 0.05 })
    static let median = AnalysisScoreFilter({ 40.0...60.0 ~= $0 })
}
