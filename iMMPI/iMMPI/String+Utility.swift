import Foundation

extension String {
    var mmpiTransliterated: String {
        let mutable = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutable, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutable, nil, kCFStringTransformStripCombiningMarks, false)
        return mutable as String
    }


    var uppercasedFirstCharacter: String {
        guard false == isEmpty else {
            return self
        }

        return substring(to: index(after: startIndex)).uppercased()
    }
}
