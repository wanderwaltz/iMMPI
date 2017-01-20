import Foundation

extension HtmlReportGenerator {
    static func answers(questionnaire: Questionnaire) -> HtmlReportGenerator? {
        return try? HtmlReportGenerator(title: Strings.Report.answers) { record, analyser in
            var elements: [Html] = []

            for i in 0..<questionnaire.statementsCount {
                let statement = questionnaire.statement(at: i)!

                let answer = record.testAnswers.answer(for: statement.statementID)

                elements.append(.li(attributes: answer == .positive ? ["class": "highlighted"] : [:],
                                    content: [
                                        .tag("index", content: .content("\(i+1).")),
                                        .tag("text", content: .content(statement.text)),
                                        .tag("score", content: .content("\(answer == .positive ? "+" : "-")"))
                    ]))
            }
            
            return .ul(attributes: ["class": "analysis"], content: elements)
        }
    }
}

