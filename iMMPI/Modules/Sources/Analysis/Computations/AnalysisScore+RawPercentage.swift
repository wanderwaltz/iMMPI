import Foundation
import DataModel

extension AnalysisScore {
    /// Returns a score computed by counting the percentage of matches between the given `Answers` instance
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
    static func rawPercentage(
        _ statements: RawMatchesKey,
        filter includeStatement: StatementsFilter =
            AnalysisScore.defaultStatementsFilter
    ) -> AnalysisScore {
        let filteredStatements = apply(includeStatement, to: statements)

        let rawMatches = AnalysisScore.raw(statements)

        return AnalysisScore(
            formatter: .percentage,
            value: .specific({ gender in
                let selectedStatements = filteredStatements.value(for: gender)
                let totalCount = Double(
                    selectedStatements.positive.count +
                        selectedStatements.negative.count
                )

                guard totalCount > 0 else {
                    return { _ in
                        AnalysisScoreComputation(
                            positiveKey: [],
                            negativeKey: [],
                            log: [
                                "В шкале не задан ни один вопрос, считаем, что это 100% совпадение"
                            ],
                            score: 100
                        )
                    }
                }

                return { answers in
                    var computation = rawMatches.value(for: gender, answers: answers)
                    let result = trunc(computation.score * 100.0 / totalCount)
                    computation.log("Cовпадений: \(Int(result))% = \(computation.score) * 100 / \(totalCount)")
                    computation.score = result
                    precondition(0.0...100.0 ~= result)
                    return computation
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
    static func rawPercentage(
        positive: [Statement.Identifier],
        negative: [Statement.Identifier],
        filter includeStatement: @escaping StatementsFilter =
            AnalysisScore.defaultStatementsFilter
    ) -> AnalysisScore {
        return .rawPercentage(
            .common((positive: positive, negative: negative)),
            filter: includeStatement
        )
    }
}
