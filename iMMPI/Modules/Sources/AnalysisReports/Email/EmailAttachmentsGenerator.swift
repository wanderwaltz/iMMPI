import Foundation
import EmailComposing
import Analysis

public struct EmailAttachmentsGenerator {
    public init(_ generators: [AttachmentReportGenerator]) {
        self.generators = generators
    }

    fileprivate let generators: [AttachmentReportGenerator]
}


extension EmailAttachmentsGenerator: AnalysisReportGenerator {
    public var title: String {
        return "com.immpi.reports.email.attachments"
    }

    public func generate(for result: AnalysisResult) -> [Attachment] {
        return generators.map({ $0.generate(for: result) })
    }
}


extension EmailAttachmentsGenerator {
    static let empty = EmailAttachmentsGenerator([])
}
