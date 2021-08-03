import Foundation
import DataModel
import Analysis
import AnalysisReports

public final class AnalysisMenuActionContext {
    public let router: Router?
    public let result: AnalysisResult

    public private(set) lazy var questionnaire: Questionnaire? = {
        try? Questionnaire(gender: self.record.person.gender, ageGroup: self.record.person.ageGroup)
    }()

    public private(set) lazy var htmlReportGenerators: [HtmlReportGenerator] = {
        let answers = self.questionnaire.flatMap({ HtmlReportGenerator.answers(questionnaire: $0) })

        return [
            .overall,
            .brief,
            answers,
        ]
        .compactMap({ $0 })
    }()

    public private(set) lazy var docxReportGenerators: [DocxReportGenerator] = {
        let answers = self.questionnaire.flatMap({ DocxReportGenerator.answers(questionnaire: $0) })

        return [
            .overall,
            answers,
        ]
        .compactMap({ $0 })
    }()

    public private(set) lazy var emailMessageGenerator: EmailMessageGenerator = {
        var attachmentGenerators: [AttachmentReportGenerator] = []

        attachmentGenerators.append(contentsOf: self.docxReportGenerators.map({ generator in
            AttachmentReportGenerator(
                titleFormatter: { $0 },
                docxGenerator: generator
            )
        }))

        return EmailMessageGenerator(attachments: EmailAttachmentsGenerator(attachmentGenerators))
    }()

    public init(router: Router?, result: AnalysisResult) {
        self.router = router
        self.result = result
    }
}


extension AnalysisMenuActionContext {
    public var record: RecordProtocol {
        return result.record
    }
}

extension String {
    var transliterated: String {
        return applyingTransform(.toLatin, reverse: false)?
            .applyingTransform(.stripCombiningMarks, reverse: false)?
            .applyingTransform(.stripDiacritics, reverse: false) ?? self
    }
}
