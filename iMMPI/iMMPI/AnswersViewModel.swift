import Foundation

protocol AnswersViewModel: AnyObject {
    var record: RecordProtocol { get }
    var statementsCount: Int { get }

    func statement(at index: Int) -> Statement?
}


final class DefaultAnswersViewModel {
    let record: RecordProtocol
    let questionnaire: Questionnaire

    init(record: RecordProtocol, questionnaire: Questionnaire) {
        self.record = record
        self.questionnaire = questionnaire
    }
}


extension DefaultAnswersViewModel: AnswersViewModel {
    var statementsCount: Int {
        return questionnaire.statementsCount
    }

    func statement(at index: Int) -> Statement? {
        return questionnaire.statement(at: index)
    }
}
