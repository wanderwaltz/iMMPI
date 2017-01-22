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
