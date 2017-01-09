import Foundation

extension String {
    var uppercasedFirstCharacter: String {
        guard false == isEmpty else {
            return self
        }

        return substring(to: index(after: startIndex)).uppercased()
    }
}
