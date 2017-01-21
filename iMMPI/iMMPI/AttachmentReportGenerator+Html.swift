import Foundation

extension AttachmentReportGenerator {
    init(titleFormatter: @escaping (String) -> String, htmlGenerator: HtmlReportGenerator) {
        self.init(
            title: htmlGenerator.title,
            generate: { record, analyser in
                let html = htmlGenerator.generate(for: record, with: analyser)

                return Attachment(
                    fileName: "\(titleFormatter(htmlGenerator.title)).html",
                    mimeType: .html,
                    data: html.description.data(using: .utf8)!
                )
        })
    }
}
