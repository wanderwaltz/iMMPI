import Foundation

struct BoundScale {
    let identifier: AnalysisScale.Identifier
    let title: String
    let index: Int
    let score: ComputedScore
    let record: TestRecordProtocol
}


extension BoundScale {
    init(scale: AnalysisScale, record: TestRecordProtocol) {
        self.init(
            identifier: scale.identifier,
            title: scale.title,
            index: scale.index.value(for: record),
            score: ComputedScore(scale: scale, record: record),
            record: record
        )
    }
}


extension AnalysisScale {
    func bind(_ record: TestRecordProtocol) -> BoundScale {
        return BoundScale(scale: self, record: record)
    }
}
