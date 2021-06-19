import Foundation
import DataModel
import Analysis
import Formatters

public final class ScaleDetailsViewModel {
    typealias Computation = (title: String, body: String)

    private(set) lazy var positiveKey: [Statement.Identifier] = computation.positiveKey
    private(set) lazy var negativeKey: [Statement.Identifier] = computation.negativeKey
    private(set) lazy var computationDetails: [Computation] = _computationDetails()

    private let record: RecordProtocol
    private let scale: AnalysisScale
    private lazy var computation: AnalysisScoreComputation = scale.score.value(for: record)

    public init(record: RecordProtocol, scale: AnalysisScale) {
        self.record = record
        self.scale = scale
    }

    private func _computationDetails() -> [Computation] {
        computation.log.map { logEntry -> Computation in
            var components = logEntry.components(separatedBy: ":")

            if components.count <= 1 {
                components.insert("", at: 0)
            }

            return (
                title: components.first!.trimmingCharacters(in: .whitespaces),
                body: components.dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespaces)
            )
        }
    }
}

extension ScaleDetailsViewModel {
    var title: String {
        "\(DateFormatter.short.string(from: record.date)) – \(scale.title)"
    }

    func hasPositiveMatch(atIndex index: Int) -> Bool {
        record.answers.answer(for: positiveKey[index]) == .positive
    }

    func hasNegativeMatch(atIndex index: Int) -> Bool {
        record.answers.answer(for: negativeKey[index]) == .negative
    }
}
