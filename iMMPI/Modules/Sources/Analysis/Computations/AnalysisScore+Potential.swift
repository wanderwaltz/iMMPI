import Foundation

extension AnalysisScore {
    enum IntellectualPotentialType: String {
        case scientific = "Научный"
        case artistic = "Артистический"
        case religious = "Религиозный"
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
                var computation = AnalysisScoreComputation()
                computation.score = -1

                let raw_i99 = AnalysisScore.raw_i99.value(for: gender, answers: answers).score
                computation.log("Формульные единицы по шкале 99: \(raw_i99)")

                // FIXME: returning -1.0 for legacy reasons; update tests to allow more sane value
                guard false == raw_i99.isNaN else {
                    computation.log("Формульные единицы по шкале 99 == NaN, не считаем дальше")
                    return computation
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
                let raw_i100 = AnalysisScore.rawPercentage_i100.value(for: gender, answers: answers).score
                computation.log("Совпадений по шкале 100: \(raw_i100)%")

                let raw_i101 = AnalysisScore.rawPercentage_i101.value(for: gender, answers: answers).score
                computation.log("Совпадений по шкале 101: \(raw_i101)%")

                let raw_i102 = AnalysisScore.rawPercentage_i102.value(for: gender, answers: answers).score
                computation.log("Совпадений по шкале 102: \(raw_i102)%")

                let x = trunc(raw_i100 + raw_i101 + raw_i102)
                computation.log("X: \(x) = \(raw_i100) + \(raw_i101) + \(raw_i102)")

                guard x > 0 else {
                    computation.log("Сумма по шкалам 100-102 отрицательная, не считаем дальше")
                    return computation
                }

                //---------------------------------------------------
                // Подсчет формульных единиц по шкалам 100-102
                //---------------------------------------------------
                // Формульные единицы нормализуются в соответствии с выражениями,
                // перечисленными в "Большой толстой книге":
                let i100 = trunc(raw_i100 * raw_i99 / x)
                computation.log("Нормализация шкалы 100: \(i100) = \(raw_i100) * \(raw_i99) / \(x)")

                let i101 = trunc(raw_i101 * raw_i99 / x)
                computation.log("Нормализация шкалы 101: \(i101) = \(raw_i101) * \(raw_i99) / \(x)")

                let i102 = trunc(raw_i102 * raw_i99 / x)
                computation.log("Нормализация шкалы 102: \(i102) = \(raw_i102) * \(raw_i99) / \(x)")


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
                computation.log("\(min.score) <= \(med.score) <= \(max.score)")

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
                computation.log("Максимальная D: \(maxDelta) = \(max.score) - \(min.score)")

                let medDelta = med.score - min.score
                computation.log("Медианная D: \(medDelta) = \(med.score) - \(min.score)")

                var maxFinal = 0.0
                var medFinal = 0.0
                let minFinal = 3.0 // В таком случае минимальный балл всегда получит 3 очка

                // Наши значения умножены на 10 лишний раз, поэтому берем целые числа вместо десятых долей.
                // Вычисляем баллы для максимального значения по формуле из книги.
                if maxDelta > 4 {
                    maxFinal = 5
                    computation.log("Максимальная D превышает 4, максимальный балл – \(maxFinal)")
                }
                else if maxDelta > 2 {
                    maxFinal = 4
                    computation.log("Максимальная D превышает 2, максимальный балл – \(maxFinal)")
                }
                else {
                    maxFinal = 3
                    computation.log("Максимальная D не превышает 2, максимальный балл – \(maxFinal)")
                }

                // Вычисляем баллы для среднего значения по формуле из книги
                if medDelta > 4 {
                    medFinal = 5
                    computation.log("Медианная D превышает 4, средний балл – \(medFinal)")
                }
                else if medDelta > 2 {
                    medFinal = 4
                    computation.log("Медианная D превышает 4, средний балл – \(medFinal)")
                }
                else {
                    medFinal = 3
                    computation.log("Медианная D не превышает 2, средний балл – \(medFinal)")
                }

                // Минимальное значение получает 3 балла по умолчанию, поэтому для него ничего
                // вычислять уже не нужно.

                // Сопоставляем полученные балы соответствующим шкалам
                let finalScores: [IntellectualPotentialType:Double] = [
                    max.type: maxFinal,
                    med.type: medFinal,
                    min.type: minFinal
                ]

                computation.log("Потенциалы:")

                for item in finalScores.sorted(by: { $0.value < $1.value }) {
                    computation.log("  \(item.key.rawValue): \(item.value)")
                }

                computation.score = finalScores[type]!
                computation.log("Финальный балл: \(computation.score)")
                return computation
                }
            })
        )
    }
}
