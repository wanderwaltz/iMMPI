import Foundation

public enum Html: CustomStringConvertible {
    public typealias Attributes = [String:CustomStringConvertible]

    case content(CustomStringConvertible)
    case joined([Html])

    public var description: String {
        switch self {
        case let .content(text): return String(describing: text)
        case let .joined(html): return html.map({ String(describing: $0) }).joined(separator: "\n")
        }
    }

    public static let empty: Html = .content("")


    public static func document(_ content: Html...) -> Html {
        return .content(Block(
            open: "<!DOCTYPE html>",
            close: "",
            content: .joined(content)
        ))
    }


    public static func html(_ content: Html...) -> Html {
        return html(content: content)
    }


    public static func html(content: [Html]) -> Html {
        return tag("html", content: .joined(content))
    }


    public static func head(_ content: Html...) -> Html {
        return head(content: content)
    }


    public static func head(content: [Html]) -> Html {
        return tag("head", content: .joined(content))
    }


    public static func meta() -> Html {
        return .content("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>")
    }


    public static func style(_ content: String) -> Html {
        return tag("style", attributes: ["type": "text/css"], content: .content(content))
    }


    public static func body(_ content: Html...) -> Html {
        return body(content: content)
    }


    public static func body(content: [Html]) -> Html {
        return tag("body", content: .joined(content))
    }


    public static func h1(_ text: String) -> Html {
        return tag("h1", content: .content(text))
    }


    public static func h2(_ text: String) -> Html {
        return tag("h2", content: .content(text))
    }


    public static func h3(_ text: String) -> Html {
        return tag("h3", content: .content(text))
    }


    public static func ul(attributes: Attributes = [:], _ content: Html...) -> Html {
        return ul(attributes: attributes, content: content)
    }


    public static func ul(attributes: Attributes = [:], content: [Html]) -> Html {
        return tag("ul", attributes: attributes, content: .joined(content))
    }


    public static func li(attributes: Attributes = [:], _ content: Html...) -> Html {
        return li(attributes: attributes, content: content)
    }


    public static func li(attributes: Attributes = [:], content: [Html]) -> Html {
        return tag("li", attributes: attributes, content: .joined(content))
    }


    public static func tag(
        _ name: String,
        attributes: [String:CustomStringConvertible] = [:],
        content: Html
    ) -> Html {
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


extension Html: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }

    public static func == (left: Html, right: Html) -> Bool {
        return left.description == right.description
    }
}
