import Foundation

extension HtmlReportGenerator {
    fileprivate typealias GroupStatement = (statement: Statement, expected: AnswerType)

    static func details(for group: AnalyzerGroup, questionnaire: Questionnaire) -> HtmlReportGenerator? {
        return try? HtmlReportGenerator(title: group.name) { record, analyser in
            var elements: [Html] = []

            var statements: [GroupStatement] = []

            statements.append(contentsOf: group.positiveStatementIDs(forRecord: record).map({
                (statement: questionnaire.statement(id: $0.intValue)!, expected: .positive)
            }))

            statements.append(contentsOf: group.negativeStatementIDs(forRecord: record).map({
                (statement: questionnaire.statement(id: $0.intValue)!, expected: .negative)
            }))

            statements.sort(by: { a, b in a.statement.statementID < b.statement.statementID })
            statements = statements.filter({ analyser.isValidStatementID($0.statement.statementID) })

            for item in statements {
                let statement = item.statement
                let expected = item.expected

                let answer = record.testAnswers.answer(for: statement.statementID)

                elements.append(
                    .li(attributes: answer != expected ? ["class": "highlighted"] : [:],
                        content: [
                            .tag("index", content: .content("\(statement.statementID).")),
                            .tag("text", content: .content(statement.text)),
                            .tag("score", content:
                                .content("о: \(answer == .positive ? "+" : "-"), ш: \(expected == .positive ? "+" : "-")")),
                        ]))
            }

            return .joined([
                .h3("\(group.name): \(group.readableScore())"),
                .ul(attributes: ["class": "analysis"], content: elements)
                ])
        }
    }
}
