import Foundation

struct AnalysisScale {
    let identifier: Identifier
    let title: String
    let index: GenderBasedValue<Int>
    let formatter: AnalysisScoreFormatter
    let score: AnalysisScore

    init(identifier: Identifier,
         title: String,
         index: GenderBasedValue<Int>,
         formatter: AnalysisScoreFormatter,
         score: AnalysisScore) {
        self.identifier = identifier
        self.title = title
        self.index = index
        self.formatter = formatter
        self.score = score
    }
}


extension AnalysisScale {
    static func dummy(identifier: Identifier, title: String) -> AnalysisScale {
        return AnalysisScale(
            identifier: identifier,
            title: title,
            index: .common(0),
            formatter: .ignore,
            score: .constant(.nan)
        )
    }
}


extension AnalysisScale {
    struct Identifier {
        let rawValue: String
        let nesting: Int

        init(_ rawValue: String, nesting: Int = 1) {
            self.rawValue = rawValue
            self.nesting = nesting
        }
    }

}


extension AnalysisScale.Identifier: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}


extension AnalysisScale.Identifier: Hashable {
    var hashValue: Int {
        return rawValue.hashValue
    }


    static func == (left: AnalysisScale.Identifier, right: AnalysisScale.Identifier) -> Bool {
        return left.rawValue == right.rawValue
    }
}
