import Foundation

public struct EmailMessage {
    public let subject: String
    public let text: String

    public let recipients: [EmailAddress]
    public let attachments: [Attachment]

    public init(
        subject: String,
        text: String,
        recipients: [EmailAddress],
        attachments: [Attachment]
    ) {
        self.subject = subject
        self.text = text
        self.recipients = recipients
        self.attachments = attachments
    }
}
