import Foundation

struct HtmlReportGenerator {
    init(css: String, content: @escaping (TestRecordProtocol, Analyzer) -> Html) {
        self.css = css
        self.content = content
    }

    fileprivate let css: String
    fileprivate let content: (TestRecordProtocol, Analyzer) -> Html
}


extension HtmlReportGenerator: AnalysisReportGenerator {
    func generate(for record: TestRecordProtocol, with analyser: Analyzer) -> Html {
        let css = self.css
        let content = self.content

        return Html.document(
            .head(
                .meta(),
                .style(css)
            ),
            .html(
                .body(
                    content(record, analyser)
                )
            )
        )
    }
}
