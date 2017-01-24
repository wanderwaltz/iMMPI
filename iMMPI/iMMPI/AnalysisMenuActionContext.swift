import Foundation

final class AnalysisMenuActionContext {
    let router: Router?

    let record: TestRecordProtocol
    let scales: [BoundScale]


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
            AttachmentReportGenerator(titleFormatter: TransliterateToLatin, htmlGenerator: htmlGenerator)
        }))

        return EmailMessageGenerator(attachments: EmailAttachmentsGenerator(attachmentGenerators))
    }()


    init(router: Router?, record: TestRecordProtocol, scales: [BoundScale]) {
        self.router = router
        self.record = record
        self.scales = scales
    }
}
