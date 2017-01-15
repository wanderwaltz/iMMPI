import XCTest
@testable import iMMPI

final class HtmlTests: XCTestCase {
    func test__document_tag() {
        let html = Html.document { "some_text" }.description

        XCTAssertEqual(html, [
            "<!DOCTYPE html>",
            "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">",
            "    some_text"
            ].joined(separator: "\n"))
    }


    func test__html_tag() {
        let html = Html.html { "content" }.description

        XCTAssertEqual(html, [
            "<html>",
            "    content",
            "</html>"
            ].joined(separator: "\n"))
    }


    func test__html_inside_document() {
        let html = Html.document {
            Html.html {
                "content"
            }
        }.description

        XCTAssertEqual(html, [
            "<!DOCTYPE html>",
            "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">",
            "    <html>",
            "        content",
            "    </html>"
            ].joined(separator: "\n"))
    }
}
