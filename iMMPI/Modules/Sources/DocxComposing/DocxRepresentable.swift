protocol DocxRepresentable {
    var xmlString: String { get }
}

extension DocxTableCell: DocxRepresentable {
    var xmlString: String {
        """
        <w:tc>
            <w:p>
                <w:r>
                    <w:rPr>
                        \(isBold ? "<w:b/>" : "")
                        \(isItalic ? "<w:i/>" : "")
                        <w:bCs/>
                        <w:sz w:val="20"/>
                        <w:szCs w:val="21"/>
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
