import Foundation

public final class AbbreviatedNameFormatter: Formatter {
    override public func string(for obj: Any?) -> String? {
        guard let name = obj as? String else {
            return nil
        }

        let components = name.components(separatedBy: .whitespacesAndNewlines)
        var abbreviated: [String] = []

        abbreviated.append(nilToEmptyString(components.first))

        for i in 1..<components.count {
            let component = components[i]

            if false == component.isEmpty {
                abbreviated.append(
                    String(
                        format: "%@.",
                        component[component.startIndex...component.startIndex].uppercased()
                    )
                )
            }
        }

        return abbreviated.joined(separator: " ")
    }
}

func nilToEmptyString(_ value: Any?) -> String {
    return value.map { String(describing: $0) } ?? ""
}
