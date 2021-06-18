import Foundation
import DataModel

public struct AnalysisScoreComputation {
    public internal(set) var positiveKey: [Statement.Identifier]
    public internal(set) var negativeKey: [Statement.Identifier]
    public internal(set) var log: [String]

    public internal(set) var score: Double

    init(
        positiveKey: [Statement.Identifier] = [],
        negativeKey: [Statement.Identifier] = [],
        log: [String] = [],
        score: Double = 0
    ) {
        self.positiveKey = positiveKey
        self.negativeKey = negativeKey
        self.log = log
        self.score = score
    }

    mutating func log(_ message: String) {
        log.append(message)
    }
}

func + (left: AnalysisScoreComputation, right: AnalysisScoreComputation) -> AnalysisScoreComputation {
    let sum = left.score + right.score

    return .init(
        positiveKey: [],
        negativeKey: [],
        log: left.log + right.log + ["\(sum) = \(left.score) + \(right.score)"],
        score: sum
    )
}

func / (left: AnalysisScoreComputation, right: AnalysisScoreComputation) -> AnalysisScoreComputation {
    guard right.score != 0 else {
        return .init(
            positiveKey: [],
            negativeKey: [],
            log: left.log + right.log + ["0 в делителе"],
            score: .nan
        )
    }

    let result = left.score / right.score

    return .init(
        positiveKey: [],
        negativeKey: [],
        log: left.log + right.log + ["\(result) = \(left.score) / \(right.score)"],
        score: result
    )
}

func * (left: AnalysisScoreComputation, right: AnalysisScoreComputation) -> AnalysisScoreComputation {
    let result = left.score * right.score

    return .init(
        positiveKey: [],
        negativeKey: [],
        log: left.log + right.log + ["\(result) = \(left.score) * \(right.score)"],
        score: result
    )
}

func * (scalar: Double, right: AnalysisScoreComputation) -> AnalysisScoreComputation {
    let result = scalar * right.score

    return .init(
        positiveKey: [],
        negativeKey: [],
        log: right.log + ["\(result) = \(scalar) * \(right.score)"],
        score: result
    )
}

func trunc(_ score: AnalysisScoreComputation) -> AnalysisScoreComputation {
    let result = trunc(score.score)

    return .init(
        positiveKey: score.positiveKey,
        negativeKey: score.negativeKey,
        log: score.log + ["\(result) = \(score.score) без дробной части"],
        score: result
    )
}
