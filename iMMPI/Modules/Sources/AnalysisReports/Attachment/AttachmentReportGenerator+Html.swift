import Foundation
import EmailComposing
import HTMLComposing
import DocxComposing

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

    public init(
        titleFormatter: @escaping (String) -> String,
        docxGenerator: DocxReportGenerator
    ) {
        self.init(
            title: docxGenerator.title,
            generate: { result in
                guard let report = docxGenerator.generate(for: result) else {
                    return nil
                }

                do {
                    let data = try Data(contentsOf: report.url)
                    return Attachment(
                        fileName: titleFormatter(report.fileName),
                        mimeType: .docx,
                        data: data
                    )
                }
                catch {
                    return nil
                }
            }
        )
    }
}
