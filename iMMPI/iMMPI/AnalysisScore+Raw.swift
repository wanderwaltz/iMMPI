import Foundation

extension AnalysisScore {
    /// A pair of `positive` and `negative` statement identifier collections, 
    /// which is used for raw score computation.
    typealias _RawMatchesKey = (positive: [Statement.Identifier], negative: [Statement.Identifier])

    /// Gender-based pair of `positive` and `negative` statement identifier collections,
    /// which is used for raw score computation.
    typealias RawMatchesKey = GenderBasedValue<_RawMatchesKey>

    /// A filter function used for ignoring some of the statements in the questionnaire.
    ///
    /// - Parameter identifier: identifier of the statement to check for validity.
    /// - Returns: a boolean value corresponding to whether the statement is valid or not.
    typealias StatementsFilter = (_ identifier: Statement.Identifier) -> Bool


    /// Returns a score computed by counting the number of matches between the given `TestAnswers` instance
    /// and predefined sets of positive and negative statements.
    ///
    /// - Parameters:
    ///    - statements: a gender-based pair of statement identifier collections, which are used for counting matches,
    ///    - filter:     a filter function, which eliminates invalid statements from the computation. 
    ///                  Statement identifiers are filtered before counting matches, so filtered out statements do not
    ///                  affect the computation in any way.
    ///
    /// - Returns: an `AnalysisScore` instance, which performs the computation. The returned value is a total number
    ///            of answers in the given record, which match the values provided by the `statements` parameter.
    static func raw(_ statements: RawMatchesKey,
                    filter includeStatement: StatementsFilter
                        = AnalysisScore.defaultStatementsFilter) -> AnalysisScore {

        let filteredStatements: RawMatchesKey = apply(includeStatement, to: statements)

        return AnalysisScore(
            formatter: .integer,
            value: .specific({ gender in { answers in
                let selectedStatements = filteredStatements.value(for: gender)

                let positiveMatches = selectedStatements.positive
                    .reduce(0, { matches, identifier in
                        return answers.answer(for: identifier) == .positive ? matches + 1 : matches
                    })

                let negativeMatches = selectedStatements.negative
                    .reduce(0, { matches, identifier in
                        return answers.answer(for: identifier) == .negative ? matches + 1 : matches
                    })

                return Double(positiveMatches + negativeMatches)
                }}))
    }


    /// A syntactic sugar overload for raw matches computation, which is independent on the `Gender`.
    ///
    /// - Parameters:
    ///    - positive: a collection of positive statement identifiers for matching,
    ///    - negative: a collection of negative statement identifiers for matching,
    ///    - filter:   a filter function, which eliminates invalid statements from the computation.
    ///
    /// - Returns: an `AnalysisScore` instance, which performs the computation. The returned value is a total number
    ///            of answers in the given record, which match the values provided by the `positive` and `negative`
    ///            parameters.
    static func raw(positive: [Statement.Identifier],
                    negative: [Statement.Identifier],
                    filter includeStatement: @escaping StatementsFilter
                        = AnalysisScore.defaultStatementsFilter) -> AnalysisScore {
        return .raw(.common((positive: positive, negative: negative)), filter: includeStatement)
    }


    static func apply(_ filter: StatementsFilter, to key: _RawMatchesKey) -> _RawMatchesKey {
        return (positive: key.positive.filter(filter), negative: key.negative.filter(filter))
    }

    static func apply(_ filter: StatementsFilter, to key: RawMatchesKey) -> RawMatchesKey {
        return .specific(
            male: apply(filter, to: key.value(for: .male)),
            female: apply(filter, to: key.value(for: .female))
        )
    }
}
