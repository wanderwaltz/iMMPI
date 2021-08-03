import Foundation
import DataModel
import Localization
import HTMLComposing

extension HtmlReportGenerator {
    public static func answers(questionnaire: Questionnaire) -> HtmlReportGenerator? {
        return try? HtmlReportGenerator(type: Strings.Report.answers) { result in
            var elements: [Html] = []

            for i in 0..<questionnaire.statementsCount {
                let statement = questionnaire.statement(at: i)!

                let answer = result.answers.answer(for: statement.identifier)

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

