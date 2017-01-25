import Foundation

struct AttachmentReportGenerator {
    let title: String

    init(title: String, generate: @escaping (AnalysisResult) -> Attachment) {
        self.title = title
        self._generate = generate
    }

    fileprivate let _generate: (AnalysisResult) -> Attachment
}


extension AttachmentReportGenerator: AnalysisReportGenerator {
    func generate(for result: AnalysisResult) -> Attachment {
        return _generate(result)
    }
}
