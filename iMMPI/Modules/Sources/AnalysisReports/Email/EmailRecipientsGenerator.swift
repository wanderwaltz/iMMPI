import Foundation
import EmailComposing
import Analysis

public struct EmailRecipientsGenerator {
    init(_ generate: @escaping (AnalysisResult) -> [EmailAddress]) {
        _generate = generate
    }

    fileprivate let _generate: (AnalysisResult) -> [EmailAddress]
}


extension EmailRecipientsGenerator: AnalysisReportGenerator {
    public var title: String {
        return "com.immpi.reports.email.recipients"
    }

    public func generate(for result: AnalysisResult) -> [EmailAddress] {
        return _generate(result)
    }
}


extension EmailRecipientsGenerator {
    public static let defaultStorage = UserDefaults.standard
    public static let defaultKey = "com.immpi.defaults.email.recipients"

    static func stored(
        in defaults: UserDefaults = EmailRecipientsGenerator.defaultStorage,
        for key: String = EmailRecipientsGenerator.defaultKey
    ) -> EmailRecipientsGenerator {
        return EmailRecipientsGenerator({ _ in
            let rawValues: [String] = defaults.array(forKey: key) as? [String] ?? []
            return rawValues.map(EmailAddress.init)
        })
    }
}
