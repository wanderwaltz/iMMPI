import Foundation

public struct SectionIndex {
    public let indexTitles: [String]

    init(indexTitles: [String]) {
        self.indexTitles = indexTitles
    }
}


extension SectionIndex {
    public func section(forIndexTitle title: String) -> Int {
        return indexTitles.firstIndex(of: title) ?? 0
    }
}
