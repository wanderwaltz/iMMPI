import Foundation

struct EmailTextGenerator {
    init(_ generate: @escaping (TestRecordProtocol, [BoundScale]) -> String) {
        _generate = generate
    }

    fileprivate let _generate: (TestRecordProtocol, [BoundScale]) -> String
}



extension EmailTextGenerator: AnalysisReportGenerator {
    var title: String {
        return "com.immpi.reports.email.text"
    }

    func generate(for record: TestRecordProtocol, with scales: [BoundScale]) -> String {
        return _generate(record, scales)
    }
}


extension EmailTextGenerator {
    static let `default` = EmailTextGenerator({ record, _ in
        // TODO: include full profile (base scales)
        let scale = AnalysisScale.f
        return "\(scale.title): \(scale.formatter.format(scale.score.value(for: record)))"
    })
}
