import Foundation
import DataModel

public struct ComputedScore {
    public let rawValue: Double
    public let description: String
    public let isWithinNorm: Bool
}

extension ComputedScore: CustomStringConvertible {}

extension ComputedScore {
    init(scale: AnalysisScale, record: RecordProtocol) {
        let rawValue = scale.score.value(for: record).score
        self.init(
            rawValue: rawValue,
            description: scale.formatter.format(rawValue),
            isWithinNorm: scale.filter.isWithinNorm(rawValue)
        )
    }
}
