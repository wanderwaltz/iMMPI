protocol DocxRepresentable {
    var xmlString: String { get }
}

extension DocxTableCell: DocxRepresentable {
    var xmlString: String {
        """
        <w:tc>
            <w:tcPr>
                <w:tcW w:w="0" w:type="auto"/>
                <w:vAlign w:val="center"/>
            </w:tcPr>
            <w:p>
                <w:r>
                    <w:rPr>
                        \(isBold ? "<w:b/>" : "")
                        \(isItalic ? "<w:i/>" : "")
                        <w:bCs/>
                        <w:sz w:val="22"/>
                        <w:szCs w:val="22"/>
                    </w:rPr>
                    <w:t>\(text)</w:t>
                </w:r>
            </w:p>
        </w:tc>
        """
    }
}

extension DocxTableRow: DocxRepresentable {
    var xmlString: String {
        """
        <w:tr>
        \(cells.map(\.xmlString).joined(separator: "\n"))
        </w:tr>
        """
    }
}
