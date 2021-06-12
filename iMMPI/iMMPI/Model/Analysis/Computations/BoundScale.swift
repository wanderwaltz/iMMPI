import Foundation

struct BoundScale {
    let identifier: AnalysisScale.Identifier
    let title: String
    let index: Int
    let score: ComputedScore
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
    func bind(_ record: RecordProtocol) -> BoundScale {
        return BoundScale(scale: self, record: record)
    }
}
