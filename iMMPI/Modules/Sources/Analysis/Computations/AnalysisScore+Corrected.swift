import Foundation

extension AnalysisScore {
    static func corrected(
        multiplier: Double,
        score: AnalysisScore
    ) -> AnalysisScore {
        .init(value: .specific({ gender in { answers in
            let k = AnalysisScore.raw_k.value(for: gender, answers: answers).score
            var computation = score.value(for: gender, answers: answers)
            computation.log("Коррекция K = \(k)")
            computation.log("Множитель \(multiplier)")

            let score = computation.score + multiplier * k
            computation.log("Баллы после коррекции: \(score) = \(computation.score) + \(multiplier) * \(k)")
            computation.score = score
            return computation
        }}))
    }
}
