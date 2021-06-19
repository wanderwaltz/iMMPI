import Foundation

extension AnalysisScore {
    static func median(
        _ median: GenderBasedValue<Double>,
        dispersion: GenderBasedValue<Double>,
        inverted: GenderBasedValue<Bool> = .common(false),
        basedOn rawScore: AnalysisScore
    ) -> AnalysisScore {
        return AnalysisScore(
            formatter: .integer,
            filter: .median,
            value: .specific({ gender in { answers in
                var computation = rawScore.value(for: gender, answers: answers)
                let raw = computation.score

                let m = median.value(for: gender)
                computation.log("Медиана m: \(m)")

                let d = dispersion.value(for: gender)
                computation.log("Дисперсия d: \(d)")

                let sign = inverted.value(for: gender) ? -1.0 : 1.0
                let signString = sign > 0 ? "+" : "-"
                
                let result = round(50.0 + 10.0 * sign * (raw - m) / d)

                computation.log(
                    """
                    Финальный балл: \(result) = 50 \(signString) 10 * (\(raw) - \(m)) / \(d)
                    """
                )

                computation.score = result
                return computation
                }
            })
        )
    }


    static func median(
        _ median: Double,
        dispersion: Double,
        basedOn rawScore: AnalysisScore
    ) -> AnalysisScore {
        return .median(
            .common(median),
            dispersion: .common(dispersion),
            basedOn: rawScore
        )
    }
}
