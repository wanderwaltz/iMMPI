import Foundation
import DataModel

struct AnalysisResult {
    let record: RecordProtocol
    let scales: [BoundScale]
}


// TODO: conform to RecordProtocol when Record is a struct.
extension AnalysisResult {
    var person: Person {
        return record.person
    }

    var answers: Answers {
        return record.answers
    }

    var date: Date {
        return record.date
    }
}


// TODO: extract record proxy protocol and use it here
extension AnalysisResult {
    var personName: String {
        return record.personName
    }
}
