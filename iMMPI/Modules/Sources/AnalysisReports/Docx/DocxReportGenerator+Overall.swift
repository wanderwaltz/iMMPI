import Analysis
import Localization
import Formatters
import DocxComposing

extension DocxReportGenerator {
    public static let overall = DocxReportGenerator(
        title: Strings.Report.overall,
        dateFormatter: .medium,
        content: { result, edit in
            let rows = result.scales.map { scale -> DocxTableRow in
                .init(cells: [
                    scale.indexCell,
                    scale.titleCell,
                    scale.scoreCell,
                ])
            }

            edit.replaceText("##TABLE##", with: rows)
        }
    )
}

private extension BoundScale {
    var indexCell: DocxTableCell {
        .init(text: index > 0 ? "\(index)" : "")
    }

    var titleCell: DocxTableCell {
        .init(text: title, isBold: index == 0, isItalic: identifier.nesting > 1)
    }

    var scoreCell: DocxTableCell {
        .init(text: score.description)
    }
}
