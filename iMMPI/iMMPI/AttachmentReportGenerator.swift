import Foundation

struct AttachmentReportGenerator {
    let title: String

    init(title: String, generate: @escaping (TestRecordProtocol, Analyzer) -> Attachment) {
        self.title = title
        self._generate = generate
    }

    fileprivate let _generate: (TestRecordProtocol, Analyzer) -> Attachment
}


extension AttachmentReportGenerator: AnalysisReportGenerator {
    func generate(for record: TestRecordProtocol, with analyser: Analyzer) -> Attachment {
        return _generate(record, analyser)
    }
}
