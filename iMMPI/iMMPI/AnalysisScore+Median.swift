import Foundation

extension AnalysisScore {
    static func median(_ median: GenderBasedValue<Double>,
                       dispersion: GenderBasedValue<Double>,
                       basedOn rawScore: AnalysisScore) -> AnalysisScore {
        return AnalysisScore(.specific({ gender in { answers in
            let raw = rawScore.value(for: gender, answers: answers)
            let m = median.value(for: gender)
            let d = dispersion.value(for: gender)

            return round(50.0 + 10.0 * (raw - m) / d)
        }}))
    }
}
