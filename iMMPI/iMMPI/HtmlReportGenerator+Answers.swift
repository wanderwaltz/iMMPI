import Foundation

extension HtmlReportGenerator {
    static let answers = try! HtmlReportGenerator(title: Strings.Report.answers) { record, analyser in
        // TODO: link Questionnaire to record so we won't need force unwrapping here
        let questionnaire = try! Questionnaire(gender: record.person.gender, ageGroup: record.person.ageGroup)

        var elements: [Html] = []

        for i in 0..<questionnaire.statementsCount {
            let statement = questionnaire.statement(at: i)!

            let answer = record.testAnswers.answer(for: statement.statementID)

            elements.append(.li(attributes: ["class": "answer-\(answer == .positive ? "positive" : "negative")"],
                                content: [
                                    .tag("index", content: .content("\(i+1).")),
                                    .tag("text", content: .content(statement.text)),
                                    .tag("score", content: .content("\(answer == .positive ? "+" : "-")"))
                ]))
        }

        return .ul(attributes: ["class": "analysis"], content: elements)
    }
}

