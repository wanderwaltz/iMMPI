import Foundation

struct EmailTextGenerator {
    init(_ generate: @escaping (AnalysisResult) -> String) {
        _generate = generate
    }

    fileprivate let _generate: (AnalysisResult) -> String
}



extension EmailTextGenerator: AnalysisReportGenerator {
    var title: String {
        return "com.immpi.reports.email.text"
    }

    func generate(for result: AnalysisResult) -> String {
        return _generate(result)
    }
}


extension EmailTextGenerator {
    static let `default` = EmailTextGenerator({ result in
        // TODO: include full profile (base scales)
        let scale = AnalysisScale.f
        return "\(scale.title): \(scale.formatter.format(scale.score.value(for: result.record)))"
    })
}
