import Foundation
import DataModel
import Analysis

public final class AnalysisViewModel {
    var title: String {
        return person.name
    }

    let person: Person
    let records: [RecordProtocol]
    var scales: [AnalysisScale] { analyser.scales }

    var results: [AnalysisResult] { _lazyResults() }

    private let analyser: Analyser
    private var _results: [AnalysisResult] = []

    public init(records: [RecordProtocol], analyser: Analyser = Analyser()) {
        precondition(Set(records.map({ $0.personName })).count == 1, "Expected all records to be of the same person")

        guard let person = records.first?.person else {
            preconditionFailure("Expected at least one record")
        }

        self.analyser = analyser
        self.person = person
        self.records = records
    }

    private func _lazyResults() -> [AnalysisResult] {
        if _results.count != records.count {
            _results = records.map({ analyser.result(for: $0) })
        }

        return _results
    }
}
