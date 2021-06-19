public protocol DocxEditing {
    func replaceText(_ text: String, with replacement: String)
    func replaceText(_ text: String, with rows: [DocxTableRow])
}

public struct DocxTableRow {
    public let cells: [DocxTableCell]

    public init(cells: [DocxTableCell]) {
        self.cells = cells
    }
}

public struct DocxTableCell {
    public let text: String
    public let isBold: Bool
    public let isItalic: Bool

    public init(
        text: String,
        isBold: Bool = false,
        isItalic: Bool = false
    ) {
        self.text = text
        self.isBold = isBold
        self.isItalic = isItalic
    }
}
