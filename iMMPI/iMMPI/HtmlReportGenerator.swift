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


extension HtmlReportGenerator {
    enum Error: Swift.Error {
        case fileNotFound
        case failedReadingCSS
    }

    init(resource: String = "html.report",
         bundle: Bundle = Bundle.main,
         _ content: @escaping (TestRecordProtocol, Analyzer) -> Html) throws {
        guard let url = bundle.url(forResource: resource, withExtension: "css") else {
            throw Error.fileNotFound
        }

        let data = try Data(contentsOf: url)

        guard let string = String(data: data, encoding: .utf8) else {
            throw Error.failedReadingCSS
        }

        self.init(css: string, content: content)
    }
}
