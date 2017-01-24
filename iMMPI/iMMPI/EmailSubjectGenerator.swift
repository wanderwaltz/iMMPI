import Foundation

struct EmailSubjectGenerator {
    init(_ generate: @escaping (TestRecordProtocol, Analyser) -> String) {
        _generate = generate
    }

    fileprivate let _generate: (TestRecordProtocol, Analyser) -> String
}



extension EmailSubjectGenerator: AnalysisReportGenerator {
    var title: String {
        return "com.immpi.reports.email.subject"
    }

    func generate(for record: TestRecordProtocol, with analyser: Analyser) -> String {
        return _generate(record, analyser)
    }
}


extension EmailSubjectGenerator {
    static let `default` = EmailSubjectGenerator({ record, _ in
        return "\(record.personName) \(DateFormatter.medium.string(from: record.date)) \(Strings.Report.emailSubjectSuffix)"
    })
}
