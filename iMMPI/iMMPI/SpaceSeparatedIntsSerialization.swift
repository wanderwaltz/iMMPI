import Foundation

struct SpaceSeparatedIntsSerialization {
    func decode(_ data: Any?) -> [Int] {
        guard let string = data as? String else {
            return []
        }

        return string.components(separatedBy: .whitespaces).flatMap({ Int($0) })
    }
}
