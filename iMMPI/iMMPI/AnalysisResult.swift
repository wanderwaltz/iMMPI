import Foundation

struct AnalysisResult {
    let record: RecordProtocol
    let scales: [BoundScale]
}


// TODO: conform to RecordProtocol when @objc requirements are dropped
extension AnalysisResult {
    var person: Person {
        return record.person
    }

    var testAnswers: Answers {
        return record.testAnswers
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