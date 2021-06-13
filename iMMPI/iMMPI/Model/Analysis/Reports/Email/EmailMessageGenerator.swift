import Foundation
import EmailComposing
import Localization
import Analysis

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

    func generate(for result: AnalysisResult) -> EmailMessage {
        return EmailMessage(
            subject: subject.generate(for: result),
            text: text.generate(for: result),
            recipients: recipients.generate(for: result),
            attachments: attachments.generate(for: result)
        )
    }
}
