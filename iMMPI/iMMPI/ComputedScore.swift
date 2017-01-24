import Foundation

struct ComputedScore {
    let rawValue: Double
    let description: String
    let isWithinNorm: Bool
}


extension ComputedScore: CustomStringConvertible {}

extension ComputedScore {
    init(scale: AnalysisScale, record: TestRecordProtocol) {
        let rawValue = scale.score.value(for: record)
        self.init(
            rawValue: rawValue,
            description: scale.formatter.format(rawValue),
            isWithinNorm: scale.filter.isWithinNorm(rawValue)
        )
    }
}
