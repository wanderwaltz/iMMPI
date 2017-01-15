import XCTest
@testable import iMMPI

final class HtmlTests: XCTestCase {
    func test__document_tag() {
        let html = Html.document(.content("some_text")).description

        XCTAssertEqual(html, [
            "<!DOCTYPE html>",
            "    some_text"
            ].joined(separator: "\n"))
    }


    func test__html_tag() {
        let html = Html.html(.content("content")).description

        XCTAssertEqual(html, [
            "<html>",
            "    content",
            "</html>"
            ].joined(separator: "\n"))
    }


    func test__head_tag() {
        let html = Html.head(.content("content")).description

        XCTAssertEqual(html, [
            "<head>",
            "    content",
            "</head>"
            ].joined(separator: "\n"))
    }


    func test__meta_tag() {
        let html = Html.meta().description

        XCTAssertEqual(html, "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>")
    }


    func test__style_tag() {
        let html = Html.style("content").description

        XCTAssertEqual(html, [
            "<style type=\"text/css\">",
            "    content",
            "</style>"
            ].joined(separator: "\n"))
    }


    func test__body_tag() {
        let html = Html.body(.content("content")).description

        XCTAssertEqual(html, [
            "<body>",
            "    content",
            "</body>"
            ].joined(separator: "\n"))
    }


    func test__header_h1_tag() {
        let html = Html.header(.h1, content: .content("content")).description

        XCTAssertEqual(html, [
            "<h1>",
            "    content",
            "</h1>"
            ].joined(separator: "\n"))
    }


    func test__header_h2_tag() {
        let html = Html.header(.h2, content: .content("content")).description

        XCTAssertEqual(html, [
            "<h2>",
            "    content",
            "</h2>"
            ].joined(separator: "\n"))
    }


    func test__header_h3_tag() {
        let html = Html.header(.h3, content: .content("content")).description

        XCTAssertEqual(html, [
            "<h3>",
            "    content",
            "</h3>"
            ].joined(separator: "\n"))
    }


    func test__list_tag() {
        let html = Html.list(
            .content("item 1"),
            .content("item 2"),
            .content("item 3")
            ).description

        XCTAssertEqual(html, [
            "<ul>",
            "    item 1",
            "    item 2",
            "    item 3",
            "</ul>"
            ].joined(separator: "\n"))
    }


    func test__item_tag() {
        let html = Html.item(
            .content("a"),
            .content("b"),
            .content("c")
            ).description

        XCTAssertEqual(html, [
            "<li>",
            "    a",
            "    b",
            "    c",
            "</li>"
            ].joined(separator: "\n"))
    }


    func test__complex_tags() {
        let html = Html.document(
            .html(
                .body(
                    .empty
                )
            )
        ).description

        XCTAssertEqual(html, [
            "<!DOCTYPE html>",
            "    <html>",
            "        <body>",
            "        </body>",
            "    </html>"
            ].joined(separator: "\n"))
    }
}
