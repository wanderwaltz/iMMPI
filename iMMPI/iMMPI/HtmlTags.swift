import Foundation

enum Html {
    static func document(_ content: @escaping () -> CustomStringConvertible) -> CustomStringConvertible {
        return Block(
            open: Html.join([
                "<!DOCTYPE html>",
                "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
                ]),
            close: "",
            content: content
        )
    }


    static func html(_ content: @escaping () -> CustomStringConvertible) -> CustomStringConvertible {
        return tag("html", content: content)
    }


    static func tag(_ name: String,
                    attributes: [String:CustomStringConvertible] = [:],
                    content: @escaping () -> CustomStringConvertible) -> CustomStringConvertible {
        let flatAttributes = attributes.isEmpty
            ? ""
            : " " + attributes.map({ "\($0)=\"\($1)\"" }).joined(separator: " ")

        return Block(open: "<\(name)\(flatAttributes)>", close: "</\(name)>", content: content)
    }


    fileprivate struct Block: CustomStringConvertible {
        init(open: String, close: String, content: () -> CustomStringConvertible) {
            self.open = open
            self.close = close
            self.content = content()
        }

        fileprivate let open: String
        fileprivate let close: String
        fileprivate let content: CustomStringConvertible

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
        let lines = string.components(separatedBy: .newlines)
        let indentedLines = lines.map({ "    \($0)" })
        return indentedLines.joined(separator: "\n")
    }
}
