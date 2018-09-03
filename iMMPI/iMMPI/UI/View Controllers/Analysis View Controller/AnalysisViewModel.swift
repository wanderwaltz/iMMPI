import Foundation

final class AnalysisViewModel {
    var title: String {
        return person.name
    }

    let person: Person
    let results: [AnalysisResult]

    init(records: [RecordProtocol], analyser: Analyser = Analyser()) {
        precondition(Set(records.map({ $0.personName })).count == 1, "Expected all records to be of the same person")

        guard let person = records.first?.person else {
            preconditionFailure("Expected at least one record")
        }

        self.analyser = analyser
        self.person = person
        self.results = records.map({ analyser.result(for: $0) })
    }

    fileprivate let analyser: Analyser
}
