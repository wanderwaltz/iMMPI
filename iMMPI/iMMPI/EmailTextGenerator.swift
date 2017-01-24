import Foundation

struct EmailTextGenerator {
    init(_ generate: @escaping (TestRecordProtocol, Analyser) -> String) {
        _generate = generate
    }

    fileprivate let _generate: (TestRecordProtocol, Analyser) -> String
}



extension EmailTextGenerator: AnalysisReportGenerator {
    var title: String {
        return "com.immpi.reports.email.text"
    }

    func generate(for record: TestRecordProtocol, with analyser: Analyser) -> String {
        return _generate(record, analyser)
    }
}


extension EmailTextGenerator {
    static let `default` = EmailTextGenerator({ record, analyser in
        // TODO: include full profile (base scales)
        let scale = AnalysisScale.f
        return "\(scale.title): \(scale.formatter.format(scale.score.value(for: record)))"
    })
}
