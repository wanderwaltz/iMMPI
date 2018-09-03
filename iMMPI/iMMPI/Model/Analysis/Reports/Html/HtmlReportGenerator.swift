import Foundation

struct HtmlReportGenerator {
    let title: String

    init(title: String,
         dateFormatter: DateFormatter = .medium,
         css: String,
         content: @escaping (AnalysisResult) -> Html) {
        self.title = title
        self.dateFormatter = dateFormatter
        self.css = css
        self.content = content
    }

    fileprivate let dateFormatter: DateFormatter
    fileprivate let css: String
    fileprivate let content: (AnalysisResult) -> Html
}


extension HtmlReportGenerator: AnalysisReportGenerator {
    func generate(for result: AnalysisResult) -> Html {
        return Html.document(
            .head(
                .meta(),
                .style(css)
            ),
            .html(
                .body(
                    .h1(result.personName),
                    .h2(dateFormatter.string(from: result.date)),
                    content(result)
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

    init(title: String,
         resource: String = "html.report",
         bundle: Bundle = Bundle.main,
         _ content: @escaping (AnalysisResult) -> Html) throws {
        guard let url = bundle.url(forResource: resource, withExtension: "css") else {
            throw Error.fileNotFound
        }

        let data = try Data(contentsOf: url)

        guard let string = String(data: data, encoding: .utf8) else {
            throw Error.failedReadingCSS
        }

        self.init(title: title, css: string, content: content)
    }
}
