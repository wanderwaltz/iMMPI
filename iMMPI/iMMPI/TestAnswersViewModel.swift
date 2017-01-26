import Foundation

protocol TestAnswersViewModel: class {
    var record: RecordProtocol { get }
    var statementsCount: Int { get }

    var onDidUpdate: () -> () { get set }
    func setNeedsUpdate()

    func statement(at index: Int) -> Statement?
}


final class DefaultTestAnswersViewModel {
    var onDidUpdate: () -> () = Constant.void()

    let record: RecordProtocol

    init(record: RecordProtocol) {
        self.record = record
    }

    fileprivate var questionnaire: Questionnaire?
}


extension DefaultTestAnswersViewModel {
    convenience init() {
        self.init(record: Record())
    }
}


extension DefaultTestAnswersViewModel: TestAnswersViewModel {
    var statementsCount: Int {
        return questionnaire?.statementsCount ?? 0
    }

    func setNeedsUpdate() {
        DispatchQueue.global().async {
            defer {
                DispatchQueue.main.async {
                    self.onDidUpdate()
                }
            }

            guard self.questionnaire == nil else {
                return
            }

            self.questionnaire =
                try? Questionnaire(gender: self.record.person.gender, ageGroup: self.record.person.ageGroup)
        }
    }


    func statement(at index: Int) -> Statement? {
        return questionnaire?.statement(at: index)
    }
}
