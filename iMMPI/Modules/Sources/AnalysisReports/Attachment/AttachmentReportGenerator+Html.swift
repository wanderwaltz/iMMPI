import Foundation
import EmailComposing
import HTMLComposing

extension AttachmentReportGenerator {
    public init(
        titleFormatter: @escaping (String) -> String,
        htmlGenerator: HtmlReportGenerator
    ) {
        self.init(
            title: htmlGenerator.title,
            generate: { result in
                let html = htmlGenerator.generate(for: result)

                return Attachment(
                    fileName: "\(titleFormatter(htmlGenerator.title)).html",
                    mimeType: .html,
                    data: html.description.data(using: .utf8)!
                )
            }
        )
    }
}
