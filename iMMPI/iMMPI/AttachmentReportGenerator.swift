import Foundation

struct AttachmentReportGenerator {
    let title: String

    init(title: String, generate: @escaping (TestRecordProtocol, [BoundScale]) -> Attachment) {
        self.title = title
        self._generate = generate
    }

    fileprivate let _generate: (TestRecordProtocol, [BoundScale]) -> Attachment
}


extension AttachmentReportGenerator: AnalysisReportGenerator {
    func generate(for record: TestRecordProtocol, with scales: [BoundScale]) -> Attachment {
        return _generate(record, scales)
    }
}
