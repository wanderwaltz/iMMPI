import Foundation

struct AttachmentReportGenerator {
    let title: String

    init(title: String, generate: @escaping (TestRecordProtocol, Analyser) -> Attachment) {
        self.title = title
        self._generate = generate
    }

    fileprivate let _generate: (TestRecordProtocol, Analyser) -> Attachment
}


extension AttachmentReportGenerator: AnalysisReportGenerator {
    func generate(for record: TestRecordProtocol, with analyser: Analyser) -> Attachment {
        return _generate(record, analyser)
    }
}
