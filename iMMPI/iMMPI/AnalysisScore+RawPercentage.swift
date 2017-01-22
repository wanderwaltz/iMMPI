import Foundation

extension AnalysisScore {
    /// Returns a score computed by counting the percentage of matches between the given `TestAnswersProtocol` instance
    /// and predefined sets of positive and negative statements.
    ///
    /// - Parameters:
    ///    - statements: a gender-based pair of statement identifier collections, which are used for counting matches,
    ///    - filter:     a filter function, which eliminates invalid statements from the computation.
    ///                  Statement identifiers are filtered before counting matches, so filtered out statements do not
    ///                  affect the computation in any way.
    ///
    /// - Returns: an `AnalysisScore` instance, which performs the computation. The returned value is a `Double`
    ///            in 0.0...100.0 range.
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
                    let result = trunc(rawMatches.value(for: gender, answers: answers) / totalCount * 100.0)
                    precondition(0.0...100.0 ~= result)
                    return result
                }
            }))
    }


    /// A syntactic sugar overload for raw percentage computation, which is independent on the `Gender`.
    ///
    /// - Parameters:
    ///    - positive: a collection of positive statement identifiers for matching,
    ///    - negative: a collection of negative statement identifiers for matching,
    ///    - filter:   a filter function, which eliminates invalid statements from the computation.
    ///
    /// - Returns: an `AnalysisScore` instance, which performs the computation. The returned value is a `Double`
    ///            in 0.0...100.0 range.
    static func rawPercentage(positive: [StatementIdentifier],
                              negative: [StatementIdentifier],
                              filter includeStatement: @escaping StatementsFilter = AnalysisScore.defaultFilter)
        -> AnalysisScore {
            return .rawPercentage(.common((positive: positive, negative: negative)), filter: includeStatement)
    }
}
