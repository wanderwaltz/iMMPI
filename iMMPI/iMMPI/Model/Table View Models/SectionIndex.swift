import Foundation

struct SectionIndex {
    let indexTitles: [String]

    init(indexTitles: [String]) {
        self.indexTitles = indexTitles
    }
}


extension SectionIndex {
    func section(forIndexTitle title: String) -> Int {
        return indexTitles.firstIndex(of: title) ?? 0
    }
}
