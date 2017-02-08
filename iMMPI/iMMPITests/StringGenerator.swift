@testable import iMMPI

struct StringGenerator<Type: StrictlyRawRepresentable>: Sequence where Type.RawValue == String {
    func makeIterator() -> AnyIterator<Type> {
        var samplesIterator = stringSamples.makeIterator()
        return AnyIterator({
            samplesIterator.next().map(Type.init)
        })
    }
}


let stringSamples = [
    "",
    "nonempty",
    "distinct nonempty",
    "one",
    "two",
    "three",
    "four",
    "five",
    "multiple words in this string",
    "something something",
    "1 2 3",
    "456",
    "#@#$$#%%$&^&"
]
