import Foundation

extension AnalysisScore {
    static func brackets(_ brackets: GenderBasedValue<(Double, Double, Double, Double)>,
                         basedOn rawScore: AnalysisScore) -> AnalysisScore {

        checkPreconditions(for: brackets.value(for: .male))
        checkPreconditions(for: brackets.value(for: .female))
        checkPreconditions(for: brackets.value(for: .unknown))

        return AnalysisScore(.specific({ gender in { answers in
            let raw = rawScore.value(for: gender, answers: answers)
            precondition(0.0...100.0 ~= raw)

            let selectedBrackets = brackets.value(for: gender)

            let a = selectedBrackets.0
            let b = selectedBrackets.1
            let c = selectedBrackets.2
            let d = selectedBrackets.3

            var score: Double = 0.0

            if raw <= a {
                score = round(10.0 * 1.5 * raw / a)
            }
            else if raw <= b {
                score = round(10.0 * (1.5 + (raw - a) / (b - a)))
            }
            else if raw <= c {
                score = round(10.0 * (2.5 + (raw - b) / (c - b)))
            }
            else if raw <= d {
                score = round(10.0 * (3.5 + (raw - c) / (d - c)))
            }
            else {
                score = round(10.0 * (4.5 + 0.5 * (raw - d) / (100.0 - d)))
            }

            score /= 10.0

            precondition(0.0...5.0 ~= score)
            return score
            }}))
    }
}


fileprivate func checkPreconditions(for brackets: (Double, Double, Double, Double)) {
    precondition(0.0 < brackets.0)
    precondition(brackets.0 < brackets.1)
    precondition(brackets.1 < brackets.2)
    precondition(brackets.2 < brackets.3)
    precondition(brackets.3 < 100.0)
}
