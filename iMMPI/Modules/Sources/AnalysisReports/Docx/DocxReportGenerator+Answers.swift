import DataModel
import Analysis
import Localization
import Formatters
import DocxComposing

extension DocxReportGenerator {
    public static func answers(questionnaire: Questionnaire) -> DocxReportGenerator {
        return .init(
            title: Strings.Report.answers,
            dateFormatter: .medium,
            content: { result, edit in
                var rows: [DocxTableRow] = []

                result.answers.enumerateAnswers(with: { id, answer in
                    guard let statementText = questionnaire.statement(id: id)?.text else {
                        return
                    }

                    rows.append(.init(cells: [
                        .init(text: "\(id)"),
                        .init(text: statementText),
                        .init(text: answer == .positive ? "+" : "-")
                    ]))
                })

                edit.replaceText("##TABLE##", with: rows)
            }
        )
    }
}
