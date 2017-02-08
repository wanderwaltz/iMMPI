import Foundation

struct AnalysisScoreFormatter {
    let format: (Double) -> String

    init(_ format: @escaping (Double) -> String) {
        self.format = format
    }
}


extension AnalysisScoreFormatter {
    static let ignore = AnalysisScoreFormatter(Constant.value(""))
    static let bracketed = AnalysisScoreFormatter({ String(format: "%.1lf", $0) })
    static let integer = AnalysisScoreFormatter({ "\(Int($0))" })
    static let percentage = AnalysisScoreFormatter({ "\(Int($0))%" })
}
