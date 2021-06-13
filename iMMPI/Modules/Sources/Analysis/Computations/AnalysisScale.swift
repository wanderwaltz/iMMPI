import Foundation
import Utils

public struct AnalysisScale {
    public let identifier: Identifier
    public let title: String
    public let index: GenderBasedValue<Int>
    public let formatter: AnalysisScoreFormatter
    public let filter: AnalysisScoreFilter
    public let score: AnalysisScore
}


extension AnalysisScale {
    public static func dummy(identifier: Identifier, title: String) -> AnalysisScale {
        return AnalysisScale(
            identifier: identifier,
            title: title,
            index: .common(0),
            formatter: .ignore,
            filter: .never,
            score: .constant(.nan)
        )
    }

    public init(
        identifier: Identifier,
        title: String,
        index: GenderBasedValue<Int>,
        score: AnalysisScore
    ) {
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
    public struct Identifier {
        public let rawValue: String
        public let nesting: Int

        public init(_ rawValue: String, nesting: Int = 1) {
            self.rawValue = rawValue
            self.nesting = nesting
        }
    }
}


extension AnalysisScale.Identifier: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}


extension AnalysisScale.Identifier: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    public static func == (
        left: AnalysisScale.Identifier,
        right: AnalysisScale.Identifier
    ) -> Bool {
        return left.rawValue == right.rawValue
    }
}
