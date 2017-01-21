import Foundation

struct EmailSubjectGenerator {
    init(_ generate: @escaping (TestRecordProtocol, Analyzer) -> String) {
        _generate = generate
    }

    fileprivate let _generate: (TestRecordProtocol, Analyzer) -> String
}



extension EmailSubjectGenerator: AnalysisReportGenerator {
    var title: String {
        return "com.immpi.reports.email.subject"
    }

    func generate(for record: TestRecordProtocol, with analyser: Analyzer) -> String {
        return _generate(record, analyser)
    }
}


extension EmailSubjectGenerator {
    static let `default` = EmailSubjectGenerator({ record, _ in
        return "\(record.personName) \(DateFormatter.medium.string(from: record.date)) \(Strings.Report.emailSubjectSuffix)"
    })
}
