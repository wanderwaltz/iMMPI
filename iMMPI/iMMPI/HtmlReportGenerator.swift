import Foundation

struct HtmlReportGenerator {
    init(dateFormatter: DateFormatter = .medium,
         css: String,
         content: @escaping (TestRecordProtocol, Analyzer) -> Html) {
        self.dateFormatter = dateFormatter
        self.css = css
        self.content = content
    }

    fileprivate let dateFormatter: DateFormatter
    fileprivate let css: String
    fileprivate let content: (TestRecordProtocol, Analyzer) -> Html
}


extension HtmlReportGenerator: AnalysisReportGenerator {
    func generate(for record: TestRecordProtocol, with analyser: Analyzer) -> Html {
        return Html.document(
            .head(
                .meta(),
                .style(css)
            ),
            .html(
                .body(
                    .h1(record.personName),
                    .h2(dateFormatter.string(from: record.date)),
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
