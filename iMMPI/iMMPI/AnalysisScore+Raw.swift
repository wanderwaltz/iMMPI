import Foundation

extension AnalysisScore {
    static func raw(_ statements: GenderBasedValue<(positive: [StatementIdentifier], negative: [StatementIdentifier])>)
        -> AnalysisScore {
            return AnalysisScore(.specific({ gender in { answers in
                let selectedStatements = statements.value(for: gender)

                let positiveMatches = selectedStatements.positive.reduce(0, { matches, identifier in
                    return answers.answer(for: identifier) == .positive ? matches + 1 : matches
                })

                let negativeMatches = selectedStatements.negative.reduce(0, { matches, identifier in
                    return answers.answer(for: identifier) == .negative ? matches + 1 : matches
                })

                return Double(positiveMatches + negativeMatches)
            }}))
    }
}
