import Foundation

struct AnalysisResult {
    let record: TestRecordProtocol
    let scales: [BoundScale]
}


// TODO: conform to TestRecordProtocol when @objc requirements are dropped
extension AnalysisResult {
    var person: PersonProtocol {
        return record.person
    }

    var testAnswers: TestAnswersProtocol {
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
