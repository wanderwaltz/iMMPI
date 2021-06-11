import Foundation

struct AnalysisScale {
    let identifier: Identifier
    let title: String
    let index: GenderBasedValue<Int>
    let formatter: AnalysisScoreFormatter
    let filter: AnalysisScoreFilter
    let score: AnalysisScore
}


extension AnalysisScale {
    static func dummy(identifier: Identifier, title: String) -> AnalysisScale {
        return AnalysisScale(
            identifier: identifier,
            title: title,
            index: .common(0),
            formatter: .ignore,
            filter: .never,
            score: .constant(.nan)
        )
    }


    init(identifier: Identifier,
         title: String,
         index: GenderBasedValue<Int>,
         score: AnalysisScore) {
        self.identifier = identifier
        self.title = title
        self.index = index
        self.formatter = score.suggestedFormatter
        self.filter = score.suggestedFilter
        self.score = score
    }
}

// TODO: instead of explicit nesting, use /-separated identifiers
extension AnalysisScale {
    struct Identifier: StrictlyRawRepresentable {
        let rawValue: String
        let nesting: Int

        init(_ rawValue: String, nesting: Int) {
            self.rawValue = rawValue
            self.nesting = nesting
        }

        init(_ rawValue: String) {
            self.init(rawValue, nesting: 1)
        }
    }

}


extension AnalysisScale.Identifier: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}


extension AnalysisScale.Identifier: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    static func == (left: AnalysisScale.Identifier, right: AnalysisScale.Identifier) -> Bool {
        return left.rawValue == right.rawValue
    }
}
