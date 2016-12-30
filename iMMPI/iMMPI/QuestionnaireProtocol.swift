import Foundation

@objc protocol QuestionnaireProtocol {
    var statementsCount: Int { get }

    @objc(statementAtIndex:)
    func statement(at index: Int) -> Statement?

    @objc(statementWithID:)
    func statement(id: Int) -> Statement?
}
