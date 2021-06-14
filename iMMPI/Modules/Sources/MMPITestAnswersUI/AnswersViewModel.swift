import Foundation
import DataModel

public protocol AnswersViewModel: AnyObject {
    var record: RecordProtocol { get }
    var statementsCount: Int { get }

    func statement(at index: Int) -> Statement?
}


public final class DefaultAnswersViewModel {
    public let record: RecordProtocol
    let questionnaire: Questionnaire

    public init(record: RecordProtocol, questionnaire: Questionnaire) {
        self.record = record
        self.questionnaire = questionnaire
    }
}


extension DefaultAnswersViewModel: AnswersViewModel {
    public var statementsCount: Int {
        return questionnaire.statementsCount
    }

    public func statement(at index: Int) -> Statement? {
        return questionnaire.statement(at: index)
    }
}
