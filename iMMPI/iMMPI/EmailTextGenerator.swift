import Foundation

struct EmailTextGenerator {
    init(_ generate: @escaping (TestRecordProtocol, Analyzer) -> String) {
        _generate = generate
    }

    fileprivate let _generate: (TestRecordProtocol, Analyzer) -> String
}



extension EmailTextGenerator: AnalysisReportGenerator {
    var title: String {
        return "com.immpi.reports.email.text"
    }

    func generate(for record: TestRecordProtocol, with analyser: Analyzer) -> String {
        return _generate(record, analyser)
    }
}


extension EmailTextGenerator {
    static let `default` = EmailTextGenerator({ record, analyser in
        let group = analyser.group(withName: Strings.Analysis.reliabilityGroupName)
        return "\(Strings.Analysis.reliabilityGroupName): \(group?.readableScore() ?? Strings.Value.unknown)"
    })
}
