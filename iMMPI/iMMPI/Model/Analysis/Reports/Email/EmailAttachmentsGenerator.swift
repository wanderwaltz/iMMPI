import Foundation

struct EmailAttachmentsGenerator {
    init(_ generators: [AttachmentReportGenerator]) {
        self.generators = generators
    }

    fileprivate let generators: [AttachmentReportGenerator]
}


extension EmailAttachmentsGenerator: AnalysisReportGenerator {
    var title: String {
        return "com.immpi.reports.email.attachments"
    }

    func generate(for result: AnalysisResult) -> [Attachment] {
        return generators.map({ $0.generate(for: result) })
    }
}


extension EmailAttachmentsGenerator {
    static let empty = EmailAttachmentsGenerator([])
}
