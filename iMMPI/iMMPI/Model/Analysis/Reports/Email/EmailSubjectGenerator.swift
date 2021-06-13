import Foundation
import Localization

struct EmailSubjectGenerator {
    init(_ generate: @escaping (AnalysisResult) -> String) {
        _generate = generate
    }

    fileprivate let _generate: (AnalysisResult) -> String
}



extension EmailSubjectGenerator: AnalysisReportGenerator {
    var title: String {
        return "com.immpi.reports.email.subject"
    }

    func generate(for result: AnalysisResult) -> String {
        return _generate(result)
    }
}


extension EmailSubjectGenerator {
    static let `default` = EmailSubjectGenerator({ result in
        return "\(result.personName) \(DateFormatter.medium.string(from: result.date)) \(Strings.Report.emailSubjectSuffix)"
    })
}
