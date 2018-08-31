import Foundation

struct EmailMessage {
    let subject: String
    let text: String

    let recipients: [EmailAddress]
    let attachments: [Attachment]
}
