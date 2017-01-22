import Foundation

struct AnalysisScore {
    init(_ perform: GenderBasedValue<(TestAnswersProtocol) -> Double>) {
        self._perform = perform
    }

    fileprivate let _perform: GenderBasedValue<(TestAnswersProtocol) -> Double>
}


extension AnalysisScore {
    func value(for record: TestRecordProtocol) -> Double {
        return _perform.value(for: record.person.gender)(record.testAnswers)
    }
}
