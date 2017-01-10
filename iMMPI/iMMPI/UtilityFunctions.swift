import Foundation

extension String {
    var uppercasedFirstCharacter: String {
        guard false == isEmpty else {
            return self
        }

        return substring(to: index(after: startIndex)).uppercased()
    }
}


enum Constant {
    static func void<A>() -> (A) -> () {
        return { _ in () }
    }


    static func bool<A>(_ value: Bool) -> (A) -> Bool {
        return { _ in value }
    }
    

    static func string<A>(_ value: String) -> (A) -> String {
        return { _ in value }
    }
}
