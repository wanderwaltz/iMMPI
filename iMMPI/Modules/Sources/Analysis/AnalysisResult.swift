import Foundation
import DataModel

public struct AnalysisResult {
    public let record: RecordProtocol
    public let scales: [BoundScale]
}


// TODO: conform to RecordProtocol when Record is a struct.
extension AnalysisResult {
    public var person: Person {
        return record.person
    }

    public var answers: Answers {
        return record.answers
    }

    public var date: Date {
        return record.date
    }
}


// TODO: extract record proxy protocol and use it here
extension AnalysisResult {
    public var personName: String {
        return record.personName
    }
}
