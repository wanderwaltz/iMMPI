import Foundation
import EmailComposing
import HTMLComposing
import DocxComposing

extension AttachmentReportGenerator {
    public init(
        htmlGenerator: HtmlReportGenerator
    ) {
        self.init(
            title: htmlGenerator.type,
            generate: { result in
                let html = htmlGenerator.generate(for: result)

                return Attachment(
                    fileName: "\(htmlGenerator.type).html",
                    mimeType: .html,
                    data: html.description.data(using: .utf8)!
                )
            }
        )
    }

    public init(
        docxGenerator: DocxReportGenerator
    ) {
        self.init(
            title: docxGenerator.type,
            generate: { result in
                guard let report = docxGenerator.generate(for: result) else {
                    return nil
                }

                do {
                    let data = try Data(contentsOf: report.url)
                    return Attachment(
                        fileName: report.fileName,
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
