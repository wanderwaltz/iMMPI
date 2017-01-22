import Foundation

extension AnalysisScore {
    static func rawPercentage(_ statements: RawMatchesKey,
                              filter includeStatement: @escaping StatementsFilter = AnalysisScore.defaultFilter)
        -> AnalysisScore {
            let rawMatches = AnalysisScore.raw(statements)

            return AnalysisScore(.specific({ gender in
                let selectedStatements = statements.value(for: gender)
                let totalCount = Double(
                    selectedStatements.positive.filter(includeStatement).count +
                    selectedStatements.negative.filter(includeStatement).count
                )

                guard totalCount > 0 else {
                    return { _ in 100.0 }
                }

                return { answers in
                    trunc(rawMatches.value(for: gender, answers: answers) / totalCount * 100.0)
                }
            }))
    }


    static func rawPercentage(positive: [StatementIdentifier],
                              negative: [StatementIdentifier],
                              filter includeStatement: @escaping StatementsFilter = AnalysisScore.defaultFilter)
        -> AnalysisScore {
            return .rawPercentage(.common((positive: positive, negative: negative)), filter: includeStatement)
    }
}
