import Foundation

struct AnalysisResult {
    let record: Record
    let scales: [BoundScale]
}


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


extension AnalysisResult {
    var personName: String {
        return record.indexItem.personName
    }
}
