import Foundation

struct EmailMessageGenerator {
    init(subject: EmailSubjectGenerator = .default,
         text: EmailTextGenerator = .default,
         recipients: EmailRecipientsGenerator = .stored(),
         attachments: EmailAttachmentsGenerator = .empty) {
        self.subject = subject
        self.text = text
        self.recipients = recipients
        self.attachments = attachments
    }

    fileprivate let subject: EmailSubjectGenerator
    fileprivate let text: EmailTextGenerator
    fileprivate let recipients: EmailRecipientsGenerator
    fileprivate let attachments: EmailAttachmentsGenerator
}


extension EmailMessageGenerator: AnalysisReportGenerator {
    var title: String {
        return Strings.Report.email
    }

    func generate(for record: TestRecordProtocol, with analyser: Analyzer) -> EmailMessage {
        return EmailMessage(
            subject: subject.generate(for: record, with: analyser),
            text: text.generate(for: record, with: analyser),
            recipients: recipients.generate(for: record, with: analyser),
            attachments: attachments.generate(for: record, with: analyser)
        )
    }
}
