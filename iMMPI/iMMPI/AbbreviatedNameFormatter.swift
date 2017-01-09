import Foundation

final class AbbreviatedNameFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let name = obj as? String else {
            return nil
        }

        let components = name.components(separatedBy: .whitespacesAndNewlines)
        var abbreviated: [String] = []

        abbreviated.append(components.first ?? "")

        for i in 1..<components.count {
            let component = components[i]

            if false == component.isEmpty {
                abbreviated.append(
                    String(format: "%@.",
                           component.substring(to: component.index(after: component.startIndex)).uppercased()))
            }
        }

        return abbreviated.joined(separator: " ")
    }
}
