import Foundation

struct AnalysisScore {
    init(_ perform: GenderBasedValue<(TestAnswersProtocol) -> Double>) {
        self._perform = perform
    }

    fileprivate let _perform: GenderBasedValue<(TestAnswersProtocol) -> Double>
}


extension AnalysisScore {
    func value(for record: TestRecordProtocol) -> Double {
        return value(for: record.person.gender, answers: record.testAnswers)
    }

    func value(for gender: Gender, answers: TestAnswersProtocol) -> Double {
        return _perform.value(for: gender)(answers)
    }
}


extension AnalysisScore {
    static func constant(_ value: Double) -> AnalysisScore {
        return AnalysisScore(.common(Constant.double(value)))
    }
}


extension AnalysisScore {
    static let ignoredStatements = Set<StatementIdentifier>(
        [14, 33, 48, 63, 66, 69, 121, 123, 133, 151,
         168, 182, 184, 197, 200, 205, 266, 275, 293,
         334, 349, 350, 462, 464, 474, 542, 551]
    )


    static func defaultFilter(_ identifier: StatementIdentifier) -> Bool {
        return false == ignoredStatements.contains(identifier)
    }
}
