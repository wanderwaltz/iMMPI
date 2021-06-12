import Foundation

public struct Attachment {
    public let fileName: String
    public let mimeType: MimeType
    public let data: Data

    public init(
        fileName: String,
        mimeType: MimeType,
        data: Data
    ) {
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}
