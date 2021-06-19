import Foundation
import EmailComposing
import Analysis

public struct AttachmentReportGenerator {
    public let title: String

    init(title: String, generate: @escaping (AnalysisResult) -> Attachment?) {
        self.title = title
        self._generate = generate
    }

    fileprivate let _generate: (AnalysisResult) -> Attachment?
}


extension AttachmentReportGenerator: AnalysisReportGenerator {
    public func generate(for result: AnalysisResult) -> Attachment? {
        return _generate(result)
    }
}
