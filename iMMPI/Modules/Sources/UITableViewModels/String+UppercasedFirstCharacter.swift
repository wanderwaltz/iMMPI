extension String {
    var uppercasedFirstCharacter: String {
        guard false == isEmpty else {
            return self
        }

        return self[startIndex...startIndex].uppercased()
    }
}
