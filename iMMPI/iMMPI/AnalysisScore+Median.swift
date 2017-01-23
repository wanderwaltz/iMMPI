import Foundation

extension AnalysisScore {
    static func median(_ median: GenderBasedValue<Double>,
                       dispersion: GenderBasedValue<Double>,
                       inverted: GenderBasedValue<Bool> = .common(false),
                       basedOn rawScore: AnalysisScore) -> AnalysisScore {
        return AnalysisScore(
            formatter: .integer,
            filter: .median,
            value: .specific({ gender in { answers in
                let raw = rawScore.value(for: gender, answers: answers)
                let m = median.value(for: gender)
                let d = dispersion.value(for: gender)
                let sign = inverted.value(for: gender) ? -1.0 : 1.0

                return round(50.0 + 10.0 * sign * (raw - m) / d)
                }}))
    }


    static func median(_ median: Double,
                       dispersion: Double,
                       basedOn rawScore: AnalysisScore) -> AnalysisScore {
        return .median(.common(median), dispersion: .common(dispersion), basedOn: rawScore)
    }
}
