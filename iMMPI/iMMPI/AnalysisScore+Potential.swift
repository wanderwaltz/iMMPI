import Foundation

extension AnalysisScore {
    enum IntellectualPotentialType: Int {
        case scientific
        case artistic
        case religious
    }


    /// Вычисение баллов по шкалам 100-102 сложное, и я не до конца понимаю, как оно
    /// работает; формулы переносятся as-is с комментариями, написанными ранее.
    static func potential(_ type: IntellectualPotentialType) -> AnalysisScore {
        return AnalysisScore(
            formatter: .bracketed,
            filter: .bracketed,
            value: .specific({ gender in { answers in
                //---------------------------------------------------
                // Считаем для начала формульные единицы по шкале 99
                //---------------------------------------------------
                let raw_i99: AnalysisScore = .raw_i99

                // FIXME: returning -1.0 for legacy reasons; update tests to allow more sane value
                guard false == raw_i99.value(for: gender, answers: answers).isNaN else {
                    return -1.0
                }

                //---------------------------------------------------
                // Вычисляем значение X по формуле из книги
                //---------------------------------------------------
                // X - это сумма процентов совпадений по шкалам 100-102
                //
                // В реализации этой формулы на Objective-C в этом месте был вызов round, а не trunc;
                // при этом все вычисления происходили в целых числах, поэтому round там был бесполезен.
                // Возможно, из-за этого страдает точность вычислений финальных баллов, но теперь это
                // legacy, который нужно поддерживать. 
                let x: AnalysisScore = trunc(.rawPercentage_i100 + .rawPercentage_i101 + .rawPercentage_i102)

                guard x.value(for: gender, answers: answers) > 0 else {
                    return -1.0
                }

                //---------------------------------------------------
                // Подсчет формульных единиц по шкалам 100-102
                //---------------------------------------------------
                // Формульные единицы нормализуются в соответствии с выражениями,
                // перечисленными в "Большой толстой книге":
                let normalized_i100_score: AnalysisScore = trunc(.rawPercentage_i100 * raw_i99 / x)
                let normalized_i101_score: AnalysisScore = trunc(.rawPercentage_i101 * raw_i99 / x)
                let normalized_i102_score: AnalysisScore = trunc(.rawPercentage_i102 * raw_i99 / x)

                let i100 = normalized_i100_score.value(for: gender, answers: answers)
                let i101 = normalized_i101_score.value(for: gender, answers: answers)
                let i102 = normalized_i102_score.value(for: gender, answers: answers)

                // Далее необходимо упорядочить полученные значения по возрастанию,
                // но не забыть, какой шкале они соответствуют.
                var scores: [(score: Double, type: IntellectualPotentialType)] = [
                    (i100, .scientific),
                    (i101, .artistic),
                    (i102, .religious)
                ]

                scores.sort(by: { $0.score < $1.score })

                // Для удобства читаем значения из упорядоченного массива
                // в отдельные переменные
                let min = scores[0]
                let med = scores[1]
                let max = scores[2]

                // Далее необходимо воспользоваться формулой из книги:
                //
                // Оценочные баллы ставятся по следующему правилу:
                // Превышение одного показателя над другим в пределах 0.2 < D < 0.4 формульных единиц
                // оценивается в 4 балла; превышение D > 0.4 - в 5 баллов; по тому же принципу ставятся
                // 2 и 1 балла; при D < 0.2 все показатели получают 3 балла.
                //
                // Здесь мне до сих пор не ясно точно, разницу между какой парой значений
                // рассматривать в качестве D в формуле из книги - есть дельта между максимальным
                // и минимальным, есть дельта между средним и минимальным и есть дельта между
                // средним и максимальным.
                //
                // Обсуждая этот вопрос с клиентом, мы пришли к выводу, что нужно брать дельту между
                // максимальным и минимальным, для подсчета очков максимального, после чего брать
                // дельту между двумя оставшимися - средним и минимальным.
                //
                // Это кажется несколько странным, но пусть будет так.
                let maxDelta = max.score - min.score
                let medDelta = med.score - min.score

                var maxFinal = 0.0
                var medFinal = 0.0
                let minFinal = 3.0 // В таком случае минимальный балл всегда получит 3 очка

                // Наши значения умножены на 10 лишний раз, поэтому берем целые числа вместо десятых долей.
                // Вычисляем баллы для максимального значения по формуле из книги.
                if maxDelta > 4 {
                    maxFinal = 5
                }
                else if maxDelta > 2 {
                    maxFinal = 4
                }
                else {
                    maxFinal = 3
                }

                // Вычисляем баллы для среднего значения по формуле из книги
                if medDelta > 4 {
                    medFinal = 5
                }
                else if medDelta > 2 {
                    medFinal = 4
                }
                else {
                    medFinal = 3
                }

                // Минимальное значение получает 3 балла по умолчанию, поэтому для него ничего
                // вычислять уже не нужно.

                // Сопоставляем полученные балы соответствующим шкалам
                let finalScores: [IntellectualPotentialType:Double] = [
                    max.type: maxFinal,
                    med.type: medFinal,
                    min.type: minFinal
                ]

                return finalScores[type]!
                }}))
    }
}
