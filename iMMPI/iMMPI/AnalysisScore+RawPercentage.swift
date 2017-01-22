import Foundation

extension AnalysisScore {
    static func rawPercentage(_ statements:
        GenderBasedValue<(positive: [StatementIdentifier], negative: [StatementIdentifier])>) -> AnalysisScore {

        let rawMatches = AnalysisScore.raw(statements)

        return AnalysisScore(.specific({ gender in
            let selectedStatements = statements.value(for: gender)
            let totalCount = Double(selectedStatements.positive.count + selectedStatements.negative.count)

            guard totalCount > 0 else {
                return { _ in 1.0 }
            }

            return { answers in
                rawMatches.value(for: gender, answers: answers) / totalCount
            }
        }))
    }
}
