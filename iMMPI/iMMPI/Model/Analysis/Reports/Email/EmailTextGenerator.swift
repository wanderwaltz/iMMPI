import Foundation

struct EmailTextGenerator {
    init(_ generate: @escaping (AnalysisResult) -> String) {
        _generate = generate
    }

    fileprivate let _generate: (AnalysisResult) -> String
}



extension EmailTextGenerator: AnalysisReportGenerator {
    var title: String {
        return "com.immpi.reports.email.text"
    }

    func generate(for result: AnalysisResult) -> String {
        return _generate(result)
    }
}


extension EmailTextGenerator {
    static let `default` = EmailTextGenerator({ result in
        let baseScales: [AnalysisScale] = [
            .l,  // L. Ложь (неискренность)
            .f,  // F. Достоверность (невалидность)
            .k,  // K. Коррекция
            .hs, // 1. Ипохондрия (Сверхконтроль)
            .d,  // 2. Депрессия (Пессимистичность)
            .hy, // 3. Истерия
            .pd, // 4. Психопатия (Импульсивность)
            .mf, // 5. Половое развитие
            .pa, // 6. Паранойя (Ригидность)
            .pf, // 7. Психастения (Тревожность)
            .sc, // 8. Шизофрения (индивидуалистичность)
            .ma, // 9. Гипомания (оптимистичность)
            .si  // 0. Интраверсия
        ]

        var lines: [String] = []

        lines.append("\(result.personName) \(DateFormatter.medium.string(from: result.date))")
        lines.append("")
        lines.append(
            contentsOf: baseScales.map({ scale in
                "\(scale.title): \(scale.formatter.format(scale.score.value(for: result.record)))"
            })
        )

        return lines.joined(separator: "\n")
    })
}
