import Foundation

enum Html: CustomStringConvertible {
    typealias Attributes = [String:CustomStringConvertible]

    case content(CustomStringConvertible)
    case joined([Html])

    var description: String {
        switch self {
        case let .content(text): return String(describing: text)
        case let .joined(html): return html.map({ String(describing: $0) }).joined(separator: "\n")
        }
    }

    enum Header: String {
        case h1 = "h1"
        case h2 = "h2"
        case h3 = "h3"
    }

    static let empty: Html = .content("")


    static func document(_ content: Html...) -> Html {
        return .content(Block(
            open: "<!DOCTYPE html>",
            close: "",
            content: .joined(content)
        ))
    }


    static func html(_ content: Html...) -> Html {
        return html(content: content)
    }


    static func html(content: [Html]) -> Html {
        return tag("html", content: .joined(content))
    }


    static func head(_ content: Html...) -> Html {
        return head(content: content)
    }


    static func head(content: [Html]) -> Html {
        return tag("head", content: .joined(content))
    }


    static func meta() -> Html {
        return .content("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>")
    }


    static func style(_ content: String) -> Html {
        return tag("style", attributes: ["type": "text/css"], content: .content(content))
    }


    static func body(_ content: Html...) -> Html {
        return body(content: content)
    }


    static func body(content: [Html]) -> Html {
        return tag("body", content: .joined(content))
    }


    static func header(_ type: Header, content: Html) -> Html {
        return tag(type.rawValue, content: content)
    }


    static func list(attributes: Attributes = [:], _ content: Html...) -> Html {
        return list(attributes: attributes, content: content)
    }


    static func list(attributes: Attributes = [:], content: [Html]) -> Html {
        return tag("ul", attributes: attributes, content: .joined(content))
    }


    static func item(attributes: Attributes = [:], _ content: Html...) -> Html {
        return item(attributes: attributes, content: content)
    }


    static func item(attributes: Attributes = [:], content: [Html]) -> Html {
        return tag("li", attributes: attributes, content: .joined(content))
    }


    fileprivate static func tag(_ name: String,
                    attributes: [String:CustomStringConvertible] = [:],
                    content: Html) -> Html {
        let flatAttributes = attributes.isEmpty
            ? ""
            : " " + attributes.map({ "\($0)=\"\($1)\"" }).joined(separator: " ")

        return .content(Block(open: "<\(name)\(flatAttributes)>", close: "</\(name)>", content: content))
    }


    fileprivate struct Block: CustomStringConvertible {
        init(open: String, close: String, content: Html) {
            self.open = open
            self.close = close
            self.content = content
        }

        fileprivate let open: String
        fileprivate let close: String
        fileprivate let content: Html

        var description: String {
            return Html.join([
                open,
                Html.indent(String(describing: content)),
                close
                ]
                .filter({ false == $0.isEmpty })
            )
        }
    }


    fileprivate static func join(_ strings: [String]) -> String {
        return strings.joined(separator: "\n")
    }


    fileprivate static func indent(_ string: String) -> String {
        guard false == string.isEmpty else {
            return string
        }

        let lines = string.components(separatedBy: .newlines)
        let indentedLines = lines.map({ "    \($0)" })
        return indentedLines.joined(separator: "\n")
    }
}
