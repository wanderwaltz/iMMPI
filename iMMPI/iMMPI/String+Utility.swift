import Foundation

extension String {
    var transliterated: String {
        return applyingTransform(.toLatin, reverse: false)?
            .applyingTransform(.stripCombiningMarks, reverse: false)?
            .applyingTransform(.stripDiacritics, reverse: false) ?? self
    }


    var uppercasedFirstCharacter: String {
        guard false == isEmpty else {
            return self
        }

        return self[startIndex...startIndex].uppercased()
    }
}
