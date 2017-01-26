import Foundation

final class AnalysisMenuActionContext {
    let router: Router?
    let result: AnalysisResult

    private(set) lazy var questionnaire: Questionnaire? = {
        try? Questionnaire(gender: self.record.person.gender, ageGroup: self.record.person.ageGroup)
    }()


    private(set) lazy var htmlReportGenerators: [HtmlReportGenerator] = {
        let answers = self.questionnaire.flatMap({ HtmlReportGenerator.answers(questionnaire: $0) })

        return [
            .overall,
            answers,
        ]
        .flatMap({ $0 })
    }()


    private(set) lazy var emailMessageGenerator: EmailMessageGenerator = {
        var attachmentGenerators: [AttachmentReportGenerator] = []

        attachmentGenerators.append(contentsOf: self.htmlReportGenerators.map({ htmlGenerator in
            AttachmentReportGenerator(titleFormatter: { $0.mmpiTransliterated }, htmlGenerator: htmlGenerator)
        }))

        return EmailMessageGenerator(attachments: EmailAttachmentsGenerator(attachmentGenerators))
    }()


    init(router: Router?, result: AnalysisResult) {
        self.router = router
        self.result = result
    }
}


extension AnalysisMenuActionContext {
    var record: TestRecordProtocol {
        return result.record
    }
}
