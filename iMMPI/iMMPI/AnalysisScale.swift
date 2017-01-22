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
    struct Identifier {
        let rawValue: String

        init(_ rawValue: String) {
            self.rawValue = rawValue
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
