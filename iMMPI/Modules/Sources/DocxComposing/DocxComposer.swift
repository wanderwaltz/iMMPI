import Foundation
import ZIPFoundation

public final class DocxComposer {
    enum Error: Swift.Error {
        case templateBundleNotFound
        case documentXMLnotUTF8
        case documentXMLnotUTF8AfterEditing
    }

    public let fileName: String

    private let templateBundleName: String
    private let templateBundleBundle: Bundle
    private let fileManager = FileManager.default

    private var editableContent: String = ""

    public init(
        templateBundleName: String,
        templateBundleBundle: Bundle,
        fileName: String
    ) {
        self.templateBundleName = templateBundleName
        self.templateBundleBundle = templateBundleBundle
        self.fileName = fileName
    }

    public func export(
        editing: (DocxEditing) throws -> Void
    ) throws -> URL {
        guard let templateURL = templateBundleBundle.url(
            forResource: templateBundleName,
            withExtension: "bundle"
        ) else {
            throw Error.templateBundleNotFound
        }

        let tmp = URL(fileURLWithPath: NSTemporaryDirectory())
        let documentBundleURL = tmp.appendingPathComponent(fileName + ".bundle")

        if fileManager.fileExists(atPath: documentBundleURL.path) {
            try fileManager.removeItem(at: documentBundleURL)
        }

        try fileManager.copyItem(at: templateURL, to: documentBundleURL)

        let editableContentURL = documentBundleURL.appendingPathComponent("word/document.xml")
        let editableContentData = try Data(contentsOf: editableContentURL)

        guard let content = String(data: editableContentData, encoding: .utf8) else {
            throw Error.documentXMLnotUTF8
        }

        editableContent = content
        try editing(DocxEditingProxy(composer: self))

        guard let updatedEditableContentData = editableContent.data(using: .utf8) else {
            throw Error.documentXMLnotUTF8AfterEditing
        }

        try fileManager.removeItem(at: editableContentURL)
        try updatedEditableContentData.write(to: editableContentURL)

        let documentURL = tmp.appendingPathComponent(fileName)

        if fileManager.fileExists(atPath: documentURL.path) {
            try fileManager.removeItem(at: documentURL)
        }

        try fileManager.zipItem(
            at: documentBundleURL,
            to: documentURL,
            shouldKeepParent: false
        )

        try fileManager.removeItem(at: documentBundleURL)

        return documentURL
    }
}

extension DocxComposer {
    func replaceText(_ text: String, with replacement: String) {
        editableContent = editableContent.replacingOccurrences(of: text, with: replacement)
    }

    func replaceText(_ text: String, with rows: [DocxTableRow]) {
        editableContent = editableContent.replacingOccurrences(
            of: text,
            with: rows.map(\.xmlString).joined(separator: "\n")
        )
    }
}

struct DocxEditingProxy: DocxEditing {
    let composer: DocxComposer

    func replaceText(_ text: String, with replacement: String) {
        composer.replaceText(text, with: replacement)
    }

    func replaceText(_ text: String, with rows: [DocxTableRow]) {
        composer.replaceText(text, with: rows)
    }
}
