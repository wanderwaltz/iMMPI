import Foundation
import DataModel

public struct BoundScale {
    public let identifier: AnalysisScale.Identifier
    public let title: String
    public let index: Int
    public let score: ComputedScore
}

extension BoundScale {
    init(scale: AnalysisScale, record: RecordProtocol) {
        self.init(
            identifier: scale.identifier,
            title: scale.title,
            index: scale.index.value(for: record),
            score: ComputedScore(scale: scale, record: record)
        )
    }
}

extension AnalysisScale {
    public func bind(_ record: RecordProtocol) -> BoundScale {
        return BoundScale(scale: self, record: record)
    }
}
