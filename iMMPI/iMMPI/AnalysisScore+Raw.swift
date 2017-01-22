import Foundation

extension AnalysisScore {
    typealias _RawMatchesKey = (positive: [StatementIdentifier], negative: [StatementIdentifier])
    typealias RawMatchesKey = GenderBasedValue<_RawMatchesKey>
    typealias StatementsFilter = (StatementIdentifier) -> Bool

    static func raw(_ statements: RawMatchesKey,
                    filter includeStatement: @escaping StatementsFilter = AnalysisScore.defaultFilter) -> AnalysisScore {
        return AnalysisScore(.specific({ gender in { answers in
            let selectedStatements = statements.value(for: gender)

            let positiveMatches = selectedStatements.positive
                .filter(includeStatement)
                .reduce(0, { matches, identifier in
                    return answers.answer(for: identifier) == .positive ? matches + 1 : matches
                })

            let negativeMatches = selectedStatements.negative
                .filter(includeStatement)
                .reduce(0, { matches, identifier in
                    return answers.answer(for: identifier) == .negative ? matches + 1 : matches
                })

            return Double(positiveMatches + negativeMatches)
            }}))
    }
}
