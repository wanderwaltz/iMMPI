import Foundation
import Utils

public struct AnalysisScoreFormatter {
    public let format: (Double) -> String

    init(_ format: @escaping (Double) -> String) {
        self.format = format
    }
}

extension AnalysisScoreFormatter {
    public static let ignore = AnalysisScoreFormatter(Constant.value(""))
    public static let bracketed = AnalysisScoreFormatter({ String(format: "%.1lf", $0) })
    public static let integer = AnalysisScoreFormatter({ "\(Int($0))" })
    public static let percentage = AnalysisScoreFormatter({ "\(Int($0))%" })
}
