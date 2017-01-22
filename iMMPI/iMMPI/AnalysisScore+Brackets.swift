import Foundation

extension AnalysisScore {
    /// Computes the score based on the given bracket values.
    ///
    /// > Число полученных по каждому показателю очков переводится в проценты. Пятибальная
    /// > оценочная шкала исходит из срединного разброса значений представленной выборки данных
    /// > тестирования, причем гистограмма распределения образует колокообразную кривую Гаусса. Отчет
    /// > ведется от медианной точки, делящей всю совокупность значений пополам: следующие 2 точки по
    /// > обе стороны от медианной точки делят поровну каждую половину, и еще две точки представляют
    /// > такое же деление четвертей, в результате получается медианная формула
    /// > MF: A < B < C < D,
    /// > по которой строится оценочная шкала:
    /// >   - 0.0..<1.5 балла - 1/8 всех значений (меньше А);
    /// >   - 1.5..<2.5 балла - 1/8 значений (лежащие между А и В);
    /// >   - 2.5..<3.5 балла - 1/2 значений (лежащие между В и С);
    /// >   - 3.5..<4.5 балла - 1/8 значений (лежащие между С и D);
    /// >   - 4.5..<5.0 баллов - 1/8 значений (превышающие D).
    /// >
    /// > MF получены на основе статистической обработки данных из архива, насчитывающего более
    /// > 2000 анкет в отдельных случаях для мужчин и женщин получены отдельные MF, равно как по
    /// > отдельным показателям получены разные - "мужские" и "женские" - тесты.
    /// >
    /// > Собчик Л. Н. Стандартизированный многофакторный метод исследования личности
    /// > СМИЛ. – СПб.: Речь, 2000. – 219 с.
    ///
    /// - Parameters:
    ///    - brackets: the bracket values `0 < A < B < C < D < 100`, which are used for the computation,
    ///    - rawScore: the base score value, which is used for computing the resulting score. It is expected
    ///                that the base score is in `0.0...100.0` range.
    ///
    /// - Returns: the resulting score in `0.0...5.0` range.
    ///
    /// - Precondition: 
    ///    - `0 < A < B < C < D < 100`,
    ///    - `rawScore.value(for: ...)` is in `0...100` range.
    static func brackets(_ brackets: GenderBasedValue<(A: Double, B: Double, C: Double, D: Double)>,
                         basedOn rawScore: AnalysisScore) -> AnalysisScore {

        checkPreconditions(for: brackets.value(for: .male))
        checkPreconditions(for: brackets.value(for: .female))
        checkPreconditions(for: brackets.value(for: .unknown))

        return AnalysisScore(
            formatter: .bracketed,
            filter: .bracketed,
            value: .specific({ gender in { answers in
                let raw = rawScore.value(for: gender, answers: answers)
                precondition(0.0...100.0 ~= raw)

                let selectedBrackets = brackets.value(for: gender)

                let a = selectedBrackets.A
                let b = selectedBrackets.B
                let c = selectedBrackets.C
                let d = selectedBrackets.D

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

    static func brackets(_ brackets: (Double, Double, Double, Double),
                         basedOn rawScore: AnalysisScore) -> AnalysisScore {
        return .brackets(.common(brackets), basedOn: rawScore)
    }
}


fileprivate func checkPreconditions(for brackets: (Double, Double, Double, Double)) {
    precondition(0.0 < brackets.0)
    precondition(brackets.0 < brackets.1)
    precondition(brackets.1 < brackets.2)
    precondition(brackets.2 < brackets.3)
    precondition(brackets.3 < 100.0)
}
