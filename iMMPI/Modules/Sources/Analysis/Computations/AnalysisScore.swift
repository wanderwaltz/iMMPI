import Foundation
import DataModel
import Utils

public struct AnalysisScore {
    let suggestedFormatter: AnalysisScoreFormatter
    let suggestedFilter: AnalysisScoreFilter

    private let _value: GenderBasedValue<(Answers) -> AnalysisScoreComputation>

    init(
        formatter: AnalysisScoreFormatter = .ignore,
        filter: AnalysisScoreFilter = .never,
        value: GenderBasedValue<(Answers) -> AnalysisScoreComputation>
    ) {
        self.suggestedFormatter = formatter
        self.suggestedFilter = filter
        self._value = value
    }
}


extension AnalysisScore {
    public func value(for record: RecordProtocol) -> AnalysisScoreComputation {
        return value(for: record.person.gender, answers: record.answers)
    }

    public func value(for gender: Gender, answers: Answers) -> AnalysisScoreComputation {
        return _value.value(for: gender)(answers)
    }
}


extension AnalysisScore {
    static func constant(_ value: Double) -> AnalysisScore {
        return AnalysisScore(
            value: .common(
                Constant.value(
                    AnalysisScoreComputation(
                        positiveKey: [],
                        negativeKey: [],
                        log: [],
                        score: value
                    )
                )
            )
        )
    }
}


func + (left: AnalysisScore, right: AnalysisScore) -> AnalysisScore {
    return AnalysisScore(
        formatter: right.suggestedFormatter,
        filter: right.suggestedFilter,
        value: .specific({ gender in { answers in
            left.value(for: gender, answers: answers) + right.value(for: gender, answers: answers)
        }})
    )
}


func / (left: AnalysisScore, right: AnalysisScore) -> AnalysisScore {
    return AnalysisScore(
        formatter: right.suggestedFormatter,
        filter: right.suggestedFilter,
        value: .specific({ gender in { answers in
            left.value(for: gender, answers: answers)
                / right.value(for: gender, answers: answers)
        }})
    )
}


func * (left: AnalysisScore, right: AnalysisScore) -> AnalysisScore {
    return AnalysisScore(
        formatter: right.suggestedFormatter,
        filter: right.suggestedFilter,
        value: .specific({ gender in { answers in
            left.value(for: gender, answers: answers)
                * right.value(for: gender, answers: answers)
        }})
    )
}



func * (scalar: Double, score: AnalysisScore) -> AnalysisScore {
    return AnalysisScore(
        formatter: score.suggestedFormatter,
        filter: score.suggestedFilter,
        value: .specific({ gender in { answers in
            scalar * score.value(for: gender, answers: answers)
        }})
    )
}


func trunc(_ score: AnalysisScore) -> AnalysisScore {
    return AnalysisScore(
        formatter: score.suggestedFormatter,
        filter: score.suggestedFilter,
        value: .specific({ gender in { answers in
            trunc(score.value(for: gender, answers: answers))
            }})
    )
}


extension AnalysisScore {
    static let ignoredStatements = Set<Statement.Identifier>(
        [14, 33, 48, 63, 66, 69, 121, 123, 133, 151,
         168, 182, 184, 197, 200, 205, 266, 275, 293,
         334, 349, 350, 462, 464, 474, 542, 551]
    )


    static func defaultStatementsFilter(_ identifier: Statement.Identifier) -> Bool {
        return false == ignoredStatements.contains(identifier)
    }
}
