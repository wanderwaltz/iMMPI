import Foundation

extension AnalysisScale {
    // MARK: - А. НАДЕЖНОСТЬ

    /// **А. НАДЕЖНОСТЬ**
    static let group_reliability = AnalysisScale.dummy(
        identifier: .group_reliability,
        title: NSLocalizedString("А. НАДЕЖНОСТЬ", comment: "Название группы шкал")
    )


    // MARK: Общественная диссимуляция

    /// **Общественная диссимуляция**
    ///
    /// **MF:** 26-33-49-55%
    ///
    /// Тест основан на мнениях, считаемых престижными и выявляющими тенденцию респондента
    /// приукрасить себя в общественном плане отсюда кажущаяся близость показателей (Sr) и (L), которые
    /// могут коррелировать между собой, но (Sr) обычно носит сознательный характер. Соотношение
    /// (Sr)>(F) указывает, что социальные характеристики респондента являются относительно
    /// ненадежными. Такой случай может иметь место, когда тестирование проводят при приеме на
    /// работу, и тестируемого не предупреждают о последующей проверке с помощью тестов валидности.
    ///
    /// Собчик Л. Н. Стандартизированный многофакторный метод исследования личности
    /// СМИЛ. – СПб.: Речь, 2000. – 219 с.
    static let sr = AnalysisScale(
        identifier: .sr,
        title: NSLocalizedString("Общественная диссимуляция", comment: "Название шкалы"),
        index: .common(1),
        score: .brackets(
            (26, 33, 49, 55),
            basedOn:
            .rawPercentage(
                positive: [95, 143, 144, 204, 223, 232, 264, 287, 369, 373, 400, 415, 434, 461, 498, 537, 556],
                negative: [21, 30, 45, 102, 105, 195, 208, 217, 225, 231, 255, 322, 370, 374, 465, 499]
            )
        ))


    // MARK: Медицинская симуляция

    /// **Медицинская симуляция**
    ///
    /// **MF:** 12-17-33-39%
    ///
    /// Тест составляет статистику жалоб на здоровье, приведенные в вопросах симптомы
    /// различных заболеваний - в большинстве своем взаимоисключающие признаки, собственно,
    /// медицинская симуляция имеет место при (Ds-r)>(Nt). Обратное соотношение указывает на то, что
    /// респондент пренебрегает своим здоровьем. При высоком уровне (Ds-r) относительно нормального
    /// (F) следует считать медицинские показатели в целом менее надежными.
    ///
    /// Собчик Л. Н. Стандартизированный многофакторный метод исследования личности
    /// СМИЛ. – СПб.: Речь, 2000. – 219 с.
    static let ds_r = AnalysisScale(
        identifier: .ds_r,
        title: NSLocalizedString("Медицинская симуляция", comment: "Название шкалы"),
        index: .common(2),
        score: .median(
            .specific(male: 18.13, female: 11.33),
            dispersion: .specific(male: 4.18, female: 4.38),
            basedOn: .raw(
                positive: [10, 23, 24, 29, 31, 32, 44, 47, 93, 97, 104, 125, 210, 212, 226,
                           241, 247, 303, 325, 352, 360, 375, 388, 422, 438, 453, 459, 475,
                           481, 518, 525, 535, 541, 543],
                negative: [68, 83, 88, 96, 257, 306]
            )
        ))


    // MARK: Комплекс Панурга

    /// **Комплекс Панурга**
    ///
    /// **MF:** 50-55-68-72%
    ///
    /// Тест обнаруживает склонность респондента слишком часто соглашаться с теми
    /// нейтральными мнениями, в смысл формулировок которых приходится вникать. Причинами служат
    /// его природная пассивность или незаинтересованность в результатах тестирования, возможна
    /// корреляция с (F). Полученные результаты интерпретируются так же в сравнении с (Hy-s).
    ///
    /// Собчик Л. Н. Стандартизированный многофакторный метод исследования личности
    /// СМИЛ. – СПб.: Речь, 2000. – 219 с.
    static let ta = AnalysisScale(
        identifier: .ta,
        title: NSLocalizedString("Комплекс Панурга", comment: "Название шкалы"),
        index: .common(3),
        score: .brackets(
            (50, 55, 68, 72),
            basedOn:
            .rawPercentage(
                positive: [20, 26, 30, 36, 39, 54, 57, 58, 63, 67, 69, 71, 75, 78, 82, 83, 84, 89, 93, 95, 98, 100, 105, 117, 124, 134, 136, 141, 147, 221, 232, 234, 237, 250, 252, 265, 276, 280, 290, 292, 295, 302, 306, 310, 313, 315, 316, 319, 322, 367, 369, 370, 371, 372, 373, 375, 376, 378, 380, 384, 387, 395, 403, 412, 416, 426, 429, 432, 439, 440, 449, 450, 460, 462, 479, 489, 495, 500, 501, 510, 513, 514, 527, 537, 546, 552, 564],
                negative: []
            )
        ))


    // MARK: Тенденция перечить

    /// **Тенденция перечить, скрытая истерия**
    ///
    /// **MF:** 27-33-57-64%
    ///
    /// Тенденция перечить обычно находится в обратной зависимости от (Ta), но тем не менее
    /// представляет собой вполне самостоятельный показатель, где оказывает влияние такая личностная
    /// особенность, как нонконформизм, а также неверие респондента в научную значимость тестового
    /// метода вообще.
    ///
    /// Собчик Л. Н. Стандартизированный многофакторный метод исследования личности
    /// СМИЛ. – СПб.: Речь, 2000. – 219 с.
    static let hy_s = AnalysisScale(
        identifier: .hy_s,
        title: NSLocalizedString("Тенденция перечить (отрицание симптомов)", comment: "Название шкалы"),
        index: .common(4),
        score: .median(
            .specific(male: 12.52, female: 12.15),
            dispersion: .specific(male: 4.18, female: 3.52),
            basedOn: .raw(
                positive: [253],
                negative: [6, 12, 26, 30, 71, 89, 93, 109, 124, 129, 136, 141, 147, 162, 170, 172, 180, 201, 213, 234, 265, 267, 279, 289, 292]
            )
        ))


    // MARK: Защитная реакция на тест

    /// **Защитная реакция на тест**
    static let defensive_reaction = AnalysisScale(
        identifier: .defensive_reaction,
        title: NSLocalizedString("Защитная реакция на тест", comment: "Название шкалы"),
        index: .common(5),
        score: .median(
            .specific(male: 12.35, female: 12.33),
            dispersion: .specific(male: 3.06, female: 2.74),
            basedOn: .raw(
                positive: [79, 111, 160, 228, 248, 264, 296, 461, 468],
                negative: [15, 30, 71, 109, 124, 135, 142, 148, 170, 324, 383, 406, 408, 409, 416, 439, 444]
            )
        ))


    // MARK: Стремление наговорить на себя

    /// **Стремление наговорить на себя**
    static let self_bashing = AnalysisScale(
        identifier: .self_bashing,
        title: NSLocalizedString("Стремление наговорить на себя", comment: "Название шкалы"),
        index: .common(6),
        score: .median(
            .specific(male: 20.12, female: 26.94),
            dispersion: .specific(male: 6.92, female: 6.7),
            basedOn: .raw(
                positive: [28, 39, 40, 45, 80, 86, 93, 101, 110, 120, 141, 142, 172, 186, 191, 238, 252, 278, 292, 304, 316, 321, 336, 345, 351, 352, 355, 357, 359, 361, 374, 382, 416, 418, 442, 458, 487, 493, 499, 500, 506, 531],
                negative: [7, 41, 79, 131, 155, 160, 163, 231, 243, 270, 353, 407, 548]
            )
        ))


    // MARK: - Б. ЗДОРОВЬЕ

    /// **Б. ЗДОРОВЬЕ**
    static let group_health = AnalysisScale.dummy(
        identifier: .group_health,
        title: NSLocalizedString("Б. ЗДОРОВЬЕ", comment: "Название группы шкал")
    )


    // MARK: Старость (зрелость)

    /// **Старость (зрелость)**
    static let maturity = AnalysisScale(
        identifier: .maturity,
        title: NSLocalizedString("Старость (зрелость)", comment: "Название шкалы"),
        index: .common(7),
        score: .median(
            .specific(male: 72.8, female: 73.5),
            dispersion: .specific(male: 7.5, female: 8.3),
            basedOn: .raw(
                positive: [513, 26, 29, 59, 77, 118, 131, 132, 138, 155, 158, 166, 232, 233, 235, 237, 240, 255, 261, 262, 307, 369, 387, 392, 402, 406, 417, 427, 428, 435, 439, 442, 444, 458, 470, 472, 473, 491, 492, 495, 506, 510, 521, 541, 546, 548, 554, 565],
                negative: [1, 6, 9, 18, 19, 21, 28, 52, 58, 62, 63, 68, 70, 80, 81, 86, 89, 90, 95, 97, 99, 100, 109, 117, 120, 128, 133, 135, 136, 141, 142, 144, 146, 148, 157, 160, 181, 186, 223, 231, 238, 244, 248, 249, 250, 259, 266, 268, 270, 271, 274, 277, 278, 281, 283, 298, 319, 334, 343, 345, 356, 358, 367, 373, 378, 386, 396, 397, 400, 401, 410, 416, 424, 425, 430, 434, 437, 438, 447, 454, 465, 467, 475, 481, 505, 533, 542, 552, 558, 560, 561]
            )
        ))


    // MARK: Потребность в лечении (пренебрежение здоровьем)

    /// **Потребность в лечении (пренебрежение здоровьем)**
    ///
    /// **MF:** 35-40-51-55% (М), 36-42-56-60% (Ж)
    ///
    /// Кроме оценки общего здоровья тест позволяет рекомендовать периодичность
    /// профилактического врачебного осмотра, а при сравнении с (Ds-r) можно проверить, как респондент
    /// следит за здоровьем сам.
    ///
    /// Собчик Л. Н. Стандартизированный многофакторный метод исследования личности
    /// СМИЛ. – СПб.: Речь, 2000. – 219 с.
    static let nt = AnalysisScale(
        identifier: .nt,
        title: NSLocalizedString("Потребность в лечении (пренебрежение здоровьем)", comment: "Название шкалы"),
        index: .common(8),
        score: .brackets(
            .specific(
                male: (33, 40, 51, 55),  // FIXME: should the first bracket be 35 here?
                female: (36, 42, 56, 60)
            ),
            basedOn:
            .rawPercentage(
                positive: [10, 13, 16, 29, 32, 61, 67, 76, 94, 102, 106, 115, 126, 140, 172, 179, 181, 201, 204, 216, 258, 259, 297, 384, 391, 400, 413, 414, 417, 432, 450, 488, 499, 526, 530, 547, 551],
                negative: [36, 137, 198, 240, 243, 280, 281, 455, 456, 466, 523]
            )
        ))


    // MARK: Половая активность

    /// **Половая активность, сексуальный статус**
    ///
    /// **MF:** 32-36-50-55% (М), 43-48-62-65% (Ж)
    ///
    /// Высокая (Sv) обычно означает брачную неустроенность и поэтому может сочетаться с
    /// потребностью в привязанности (Hy2). Собственно (Sv) оценивается косвенно по проявляющемуся
    /// чувству сексуального голода. Напротив, низкая (Sv) означает половую пассивность или чувство
    /// брачного комфорта.
    ///
    /// Собчик Л. Н. Стандартизированный многофакторный метод исследования личности
    /// СМИЛ. – СПб.: Речь, 2000. – 219 с.
    static let sv = AnalysisScale(
        identifier: .sv,
        title: NSLocalizedString("Половая активность", comment: "Название шкалы"),
        index: .common(9),
        score: .brackets(
            .specific(
                male: (32, 36, 50, 55),
                female: (43, 48, 62, 65)
            ),
            basedOn:
            .rawPercentage(
                positive: [25, 70, 77, 78, 95, 132, 149, 203, 295, 357, 361, 416, 441, 463, 468, 488, 554, 561],
                negative: [1, 26, 79, 81, 91, 98, 99, 135, 219, 223, 249, 254, 283, 300, 316, 348, 378, 379, 426, 446, 447, 522, 537, 550, 563]
            )
        ))


    // MARK: Половые отклонения

    /// **Половые отклонения**
    ///
    /// **MF:** 27-31-42-45% (M), 30-35-45-50% (Ж)
    /// Несмотря на медицинское значение теста, он имеет определенное отношение к практике
    /// межличностных связей, так как могут ставить индивида за рамки семейных и общественных
    /// интересов, заставлять замыкаться в себе, приводить к моральным конфликтам и бояться
    /// преследования. Причины (Sdv) разные, но взаимосвязанные: алкоголизм, гомосексуализм, половая
    /// импотенция и собственно психические расстройства (шизофрения, маниакальный психоз).
    ///
    /// В профориентации важность этого показателя (как и показателей психической структуры) -
    /// не диагностика медицинской или социальной патологии, а выявление предрасположенности,
    /// отражающейся в характере и поддающейся учету и воздействию. Поэтому полученные результаты
    /// (Sdv) интерпретируются с учетом (Sd), (Sv), (Ec).
    ///
    /// Собчик Л. Н. Стандартизированный многофакторный метод исследования личности
    /// СМИЛ. – СПб.: Речь, 2000. – 219 с.
    static let sdv = AnalysisScale(
        identifier: .sdv,
        title: NSLocalizedString("Половые отклонения", comment: "Название шкалы"),
        index: .common(10),
        score: .brackets(
            .specific(
                male: (27, 31, 42, 45),
                female: (30, 35, 45, 50)
            ),
            basedOn:
            .rawPercentage(
                positive: [5, 59, 61, 67, 76, 84, 88, 94, 98, 106, 111, 118, 127, 138, 139, 140, 144, 147, 158, 168, 170, 179, 239, 249, 260, 297, 298, 303, 304, 316, 329, 346, 348, 349, 350, 352, 360, 364, 365, 373, 375, 377, 378, 382, 385, 389, 395, 404, 413, 419, 427, 444, 453, 455, 457, 458, 483, 488, 489, 490, 492, 498, 507, 548, 549, 558, 559, 562],
                negative: [6, 12, 20, 37, 39, 46, 51, 63, 89, 120, 133, 134, 155, 160, 163, 255, 289, 294, 302, 328, 347, 367, 372, 376, 379, 380, 430, 432, 449, 460, 547, 554]
            )
        ))


    // MARK: Алкоголизм 1

    /// **Алкоголизм 1**
    static let a1 = AnalysisScale(
        identifier: .a1,
        title: NSLocalizedString("Алкоголизм 1", comment: "Название шкалы"),
        index: .common(11),
        score: .median(
            .specific(male: 47, female: 58.18),
            dispersion: .specific(male: 10.6, female: 10.1),
            basedOn: .raw(
                positive: [13, 21, 38, 41, 56, 61, 70, 82, 86, 94, 100, 102, 105, 108, 118, 119, 127, 129, 138, 140, 142, 144, 145, 156, 162, 166, 171, 212, 215, 217, 224, 232, 234, 251, 254, 255, 259, 260, 266, 267, 307, 317, 319, 322, 336, 340, 361, 375, 377, 380, 390, 395, 397, 406, 411, 413, 414, 418, 421, 425, 431, 439, 442, 445, 457, 463, 467, 468, 472, 498, 499, 500, 506, 503, 531, 541, 545, 549, 554, 555],
                negative: [3, 12, 18, 20, 63, 79, 89, 95, 117, 124, 133, 143, 152, 164, 170, 175, 176, 207, 214, 230, 231, 238, 271, 276, 282, 294, 313, 329, 365, 370, 387, 391, 410, 417, 429, 449, 450, 460, 488, 513, 521, 542, 547, 561, 466]
            )
        ))


    // MARK: Алкогольная дифференциация

    /// **Алкогольная дифференциация**
    static let ad = AnalysisScale(
        identifier: .ad,
        title: NSLocalizedString("Алкогольная дифференциация", comment: "Название шкалы"),
        index: .common(12),
        score: .median(
            .specific(male: 35.5, female: 34.39),
            dispersion: .specific(male: 4.87, female: 4.95),
            basedOn: .raw(
                positive: [61, 94, 100, 102, 127, 131, 140, 215, 219, 222, 239, 427, 437, 446, 465, 477, 503, 524, 533, 554],
                negative: [26, 39, 46, 95, 144, 145, 155, 237, 264, 287, 289, 292, 294, 300, 322, 327, 337, 343, 346, 348, 351, 361, 365, 366, 375, 378, 383, 386, 387, 411, 415, 420, 421, 432, 433, 436, 459, 460, 472, 473, 483, 505, 513, 516, 555, 558, 560, 359]
            )
        ))


    // MARK: Алкоголизм 2

    /// **Алкоголизм 2**
    static let a2 = AnalysisScale(
        identifier: .a2,
        title: NSLocalizedString("Алкоголизм 2", comment: "Название шкалы"),
        index: .common(13),
        score: .median(
            .specific(male: 25.39, female: 26.85),
            dispersion: .specific(male: 4.16, female: 4.95),
            basedOn: .raw(
                positive: [5, 21, 41, 61, 127, 215, 239, 251, 277, 311, 369, 382, 446, 477, 481, 506, 524],
                negative: [9, 26, 46, 80, 95, 98, 101, 115, 137, 155, 163, 170, 183, 199, 232, 240, 249, 274, 387, 392, 395, 398, 427, 460, 461, 472, 483, 516, 522, 542, 548, 558, 560, 287, 289, 294, 343, 351, 365, 378, 384, 386]
            )
        ))


    // MARK: Предрасположенность к головным болям

    /// **Предрасположенность к головным болям**
    static let headaches = AnalysisScale(
        identifier: .headaches,
        title: NSLocalizedString("Предрасположенность к головным болям", comment: "Название шкалы"),
        index: .common(14),
        score: .median(
            .specific(male: 9.02, female: 10.75),
            dispersion: .specific(male: 1.08, female: 3.13),
            basedOn: .raw(
                positive: [5, 26, 44, 52, 72, 108, 114, 129, 136, 144, 161, 244, 265, 266, 286, 348, 453, 468, 513],
                negative: [99, 103, 175, 421, 428, 457, 467, 479, 547]
            )
        ))


    // MARK: Соматические жалобы

    /// **Соматические жалобы**
    static let soma_complaints = AnalysisScale(
        identifier: .soma_complaints,
        title: NSLocalizedString("Соматические жалобы", comment: "Название шкалы"),
        index: .common(15),
        score: .median(
            .specific(male: 2.37, female: 4.95),
            dispersion: .specific(male: 2, female: 2.37),
            basedOn: .raw(
                positive: [10, 23, 44, 47, 114, 186],
                negative: [7, 55, 103, 174, 175, 188, 190, 192, 230, 243, 274]
            )
        ))


    // MARK: Реакция соматизации

    /// **Реакция соматизации**
    static let soma_reaction = AnalysisScale(
        identifier: .soma_reaction,
        title: NSLocalizedString("Реакция соматизации", comment: "Название шкалы"),
        index: .common(16),
        score: .median(
            .specific(male: 22.48, female: 20.31),
            dispersion: .specific(male: 3.59, female: 3.62),
            basedOn: .raw(
                positive: [49, 53, 54, 57, 73, 95, 96, 125, 170, 272, 329, 407, 476, 488, 554],
                negative: [24, 30, 36, 51, 61, 75, 76, 106, 146, 150, 153, 163, 168, 171, 224, 225, 236, 241, 285, 299, 303, 352, 361, 397, 425, 441, 442, 443, 448, 508, 524, 533]
            )
        ))


    // MARK: Физические расстройства

    /// **Физические расстройства**
    static let physical_disorders = AnalysisScale(
        identifier: .physical_disorders,
        title: NSLocalizedString("Физические расстройства", comment: "Название шкалы"),
        index: .common(17),
        score: .median(
            .specific(male: 3, female: 4),
            dispersion: .specific(male: 1, female: 2),
            basedOn: .raw(
                positive: [130, 189, 193, 288],
                negative: [2, 18, 51, 153, 154, 155, 160]
            )
        ))
}
