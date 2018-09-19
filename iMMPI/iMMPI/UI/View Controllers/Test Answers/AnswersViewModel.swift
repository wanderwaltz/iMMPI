import Foundation

protocol AnswersViewModel: class {
    var record: Record { get }
    var statementsCount: Int { get }

    func statement(at index: Int) -> Statement?
}


final class DefaultAnswersViewModel {
    let record: Record
    let questionnaire: Questionnaire

    init(record: Record, questionnaire: Questionnaire) {
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
