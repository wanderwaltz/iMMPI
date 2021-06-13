import Foundation
import EmailComposing
import Localization
import Analysis

public struct EmailMessageGenerator {
    public init(attachments: EmailAttachmentsGenerator) {
        self.init(
            subject: .default,
            text: .default,
            recipients: .stored(),
            attachments: attachments
        )
    }

    init(
        subject: EmailSubjectGenerator,
        text: EmailTextGenerator,
        recipients: EmailRecipientsGenerator,
        attachments: EmailAttachmentsGenerator
    ) {
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
    public var title: String {
        return Strings.Report.email
    }

    public func generate(for result: AnalysisResult) -> EmailMessage {
        return EmailMessage(
            subject: subject.generate(for: result),
            text: text.generate(for: result),
            recipients: recipients.generate(for: result),
            attachments: attachments.generate(for: result)
        )
    }
}
