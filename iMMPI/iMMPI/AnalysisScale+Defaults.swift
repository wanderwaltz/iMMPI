import Foundation

extension AnalysisScale {
    // MARK: - А. НАДЕЖНОСТЬ

    /// А. НАДЕЖНОСТЬ
    static let group_reliability = AnalysisScale.dummy(
        identifier: .group_reliability,
        title: NSLocalizedString("А. НАДЕЖНОСТЬ", comment: "Название группы шкал")
    )


    // MARK: Общественная диссимуляция

    /// Общественная диссимуляция
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

    /// Медицинская симуляция
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

    /// Комплекс Панурга
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

    /// Тенденция перечить, скрытая истерия
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

    /// Защитная реакция на тест
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

    /// Стремление наговорить на себя
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

    /// Б. ЗДОРОВЬЕ
    static let group_health = AnalysisScale.dummy(
        identifier: .group_health,
        title: NSLocalizedString("Б. ЗДОРОВЬЕ", comment: "Название группы шкал")
    )


    // MARK: Старость (зрелость)

    /// Старость (зрелость)
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

    /// Потребность в лечении (пренебрежение здоровьем)
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

    /// Половая активность, сексуальный статус
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

    /// Половые отклонения
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

    /// Алкоголизм 1
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

    /// Алкогольная дифференциация
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

    /// Алкоголизм 2
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

    /// Предрасположенность к головным болям
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

    /// Соматические жалобы
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

    /// Реакция соматизации
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

    /// Физические расстройства
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


    // MARK: Психическая заторможенность

    /// Психическая заторможенность
    static let mental_block = AnalysisScale(
        identifier: .mental_block,
        title: NSLocalizedString("Психическая заторможенность", comment: "Название шкалы"),
        index: .common(18),
        score: .median(
            .specific(male: 3.16, female: 4.92),
            dispersion: .specific(male: 1.93, female: 2.38),
            basedOn: .raw(
                positive: [32, 41, 86, 104, 159, 182, 259, 290],
                negative: [8, 9, 46, 88, 122, 178, 207]
            )
        ))


    // MARK: Эпилепсия

    /// Эпилепсия
    static let epilepsy = AnalysisScale(
        identifier: .epilepsy,
        title: NSLocalizedString("Эпилепсия", comment: "Название шкалы"),
        index: .common(19),
        score: .median(
            .specific(male: 19.9, female: 23.57),
            dispersion: .specific(male: 3.84, female: 4.13),
            basedOn: .raw(
                positive: [22, 31, 32, 44, 47, 59, 62, 76, 83, 114, 146, 150, 156, 186, 189, 238, 266, 312, 335, 340, 342],
                negative: [4, 8, 9, 36, 46, 58, 68, 69, 70, 101, 103, 122, 125, 144, 154, 155, 160, 163, 174, 175, 183, 187, 188, 190, 196, 198, 213, 242, 254, 279, 281, 289, 295, 322, 329]
            )
        ))


    // MARK: Органическое поражение хвостатого ядра

    /// Органическое поражение хвостатого ядра
    static let nucleus_injury = AnalysisScale(
        identifier: .nucleus_injury,
        title: NSLocalizedString("Органическое поражение хвостатого ядра", comment: "Название шкалы"),
        index: .common(20),
        score: .median(
            .specific(male: 11, female: 14.81),
            dispersion: .specific(male: 4.56, female: 4.57),
            basedOn: .raw(
                positive: [28, 39, 76, 94, 142, 147, 159, 180, 182, 189, 236, 239, 273, 313, 338, 343, 361, 389, 499, 512, 544, 549, 551, 560],
                negative: [8, 46, 57, 69, 163, 188, 242, 407, 412, 450, 513, 523]
            )
        ))



    // MARK: - В. ПСИХИКА

    /// В. ПСИХИКА
    static let group_psyche = AnalysisScale.dummy(
        identifier: .group_psyche,
        title: NSLocalizedString("В. ПСИХИКА", comment: "Название группы шкал")
    )


    // MARK: Ложь (неискренность)

    /// Ложь (неискренность)
    static let l = AnalysisScale(
        identifier: .l,
        title: NSLocalizedString("Ложь (неискренность)", comment: "Название шкалы"),
        index: .common(21),
        score: .median(
            4.2,
            dispersion: 2.9,
            basedOn: .raw(
                positive: [],
                negative: [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 195, 225, 255, 285]
            )
        ))


    // MARK: Достоверность (невалидность)

    /// Достоверность (невалидность)
    static let f = AnalysisScale(
        identifier: .f,
        title: NSLocalizedString("Достоверность (невалидность)", comment: "Название шкалы"),
        index: .common(22),
        score: .median(
            2.76,
            dispersion: 4.67,
            basedOn: .raw(
                positive: [14, 23, 27, 31, 33, 34, 35, 40, 42, 48, 49, 50, 53, 56, 66, 85, 121, 123, 139, 146, 151, 156, 168, 184, 197, 200, 202, 205, 206, 209, 210, 211, 215, 218, 227, 245, 246, 247, 252, 256, 269, 275, 286, 291, 293],
                negative: [17, 20, 54, 65, 75, 83, 112, 113, 115, 164, 169, 177, 185, 196, 199, 220, 257, 258, 272, 276]
            )
        ))


    // MARK: Коррекция

    /// Коррекция
    static let k = AnalysisScale(
        identifier: .k,
        title: NSLocalizedString("Коррекция", comment: "Название шкалы"),
        index: .common(23),
        score: .median(
            12.1,
            dispersion: 5.4,
            basedOn: .raw_k
        ))


    // MARK: Ипохондрия (Сверхконтроль)

    /// Ипохондрия (Сверхконтроль)
    static let hs = AnalysisScale(
        identifier: .hs,
        title: NSLocalizedString("Ипохондрия (Сверхконтроль)", comment: "Название шкалы"),
        index: .common(24),
        score: .median(
            .specific(male: 11.1, female: 12.9),
            dispersion: .specific(male: 3.9, female: 4.83),
            basedOn: 0.5 * .raw_k + .raw(
                positive: [23, 29, 43, 62, 72, 108, 114, 125, 161, 189, 273],
                negative: [2, 3, 7, 9, 18, 51, 55, 63, 68, 103, 130, 153, 155, 163, 175, 188, 190, 192, 230, 243, 274, 281]
            )
        ))


    // MARK: Сверхконтроль Я (зажатость)

    /// Сверхконтроль Я (зажатость)
    static let hs_self = AnalysisScale(
        identifier: .hs_self,
        title: NSLocalizedString("Сверхконтроль Я (зажатость)", comment: "Название шкалы"),
        index: .common(25),
        score: .median(
            .specific(male: 12.02, female: 11.89),
            dispersion: .specific(male: 2.02, female: 2.99),
            basedOn: .raw(
                positive: [115, 239, 503],
                negative: [59, 99, 118, 126, 149, 165, 181, 204, 208, 231, 254, 383, 400, 406, 441, 450, 451, 481, 491, 529]
            )
        ))


    // MARK: Предипохондрическое состояние

    /// Предипохондрическое состояние
    static let hs_pre = AnalysisScale(
        identifier: .hs_pre,
        title: NSLocalizedString("Предипохондрическое состояние", comment: "Название шкалы"),
        index: .common(26),
        score: .median(
            .specific(male: 9.03, female: 16.03),
            dispersion: .specific(male: 5.04, female: 5.8),
            basedOn: .raw(
                positive: [10, 23, 24, 29, 41, 43, 44, 47, 62, 72, 108, 114, 125, 142, 159, 161, 186, 189, 238, 263, 273, 335, 439, 517],
                negative: [2, 3, 7, 9, 18, 46, 51, 55, 63, 68, 103, 128, 136, 152, 153, 163, 175, 188, 190, 192, 230, 242, 243, 248, 274, 281, 330, 407, 436, 449, 462]
            )
        ))


    // MARK: Сосредоточенность на здоровье

    /// Сосредоточенность на здоровье
    static let hs_health = AnalysisScale(
        identifier: .hs_health,
        title: NSLocalizedString("Сосредоточенность на здоровье", comment: "Название шкалы"),
        index: .common(27),
        score: .median(
            .specific(male: 5.39, female: 2.14),
            dispersion: .specific(male: 3.11, female: 2.32),
            basedOn: .raw(
                positive: [62, 189],
                negative: [2, 3, 9, 51, 55, 68, 103, 153, 163, 175, 190, 192, 230, 330]
            )
        ))


    // MARK: Чистая ипохондрия

    /// Чистая ипохондрия
    static let hs_pure = AnalysisScale(
        identifier: .hs_pure,
        title: NSLocalizedString("Чистая ипохондрия", comment: "Название шкалы"),
        index: .common(28),
        score: .median(
            .specific(male: 0.89, female: 1.64),
            dispersion: .specific(male: 1.1, female: 1.31),
            basedOn: .raw(
                positive: [29, 62, 72, 108, 125, 161],
                negative: [63, 68, 130]
            )
        ))


    // MARK: Невротический сверхконтроль

    /// Невротический сверхконтроль
    static let hs_neurotic = AnalysisScale(
        identifier: .hs_neurotic,
        title: NSLocalizedString("Невротический сверхконтроль", comment: "Название шкалы"),
        index: .common(29),
        score: .median(
            .specific(male: 5, female: 6.52),
            dispersion: .specific(male: 2.39, female: 2.2),
            basedOn: .raw(
                positive: [267, 292, 361],
                negative: [12, 187, 192, 228, 229, 242, 287, 353, 371, 401, 440, 482, 520, 528, 533]
            )
        ))


    // MARK: Невротическое ослабление сверхконтроля

    /// Невротическое ослабление сверхконтроля
    static let hs_neurotic_weak = AnalysisScale(
        identifier: .hs_neurotic_weak,
        title: NSLocalizedString("Невротическое ослабление сверхконтроля", comment: "Название шкалы"),
        index: .common(30),
        score: .median(
            .specific(male: 14.1, female: 17.03),
            dispersion: .specific(male: 4.93, female: 4.53),
            basedOn: .raw(
                positive: [39, 41, 45, 71, 80, 93, 109, 127, 145, 162, 238, 298, 316, 319, 336, 381, 383, 386, 397, 433, 439, 505, 525, 551, 566],
                negative: [8, 101, 167, 173, 369, 399, 478, 527]
            )
        ))


    // MARK: Депрессия (Пессимистичность)

    /// Депрессия (Пессимистичность)
    static let d = AnalysisScale(
        identifier: .d,
        title: NSLocalizedString("Депрессия (Пессимистичность)", comment: "Название шкалы"),
        index: .common(31),
        score: .median(
            .specific(male: 16.6, female: 18.9),
            dispersion: .specific(male: 4.11, female: 5),
            basedOn: .raw(
                positive: [5, 13, 23, 32, 41, 43, 52, 67, 86, 104, 130, 138, 142, 158, 159, 182, 189, 193, 236, 259],
                negative: [2, 8, 9, 18, 30, 36, 39, 45, 46, 51, 57, 58, 64, 80, 88, 89, 95, 98, 107, 122, 131, 152, 153, 154, 155, 160, 178, 191, 207, 208, 238, 241, 242, 248, 263, 270, 271, 272, 285, 296]
            )
        ))


    // MARK: Чистая депрессия

    /// Чистая депрессия
    static let d_pure = AnalysisScale(
        identifier: .d_pure,
        title: NSLocalizedString("Чистая депрессия", comment: "Название шкалы"),
        index: .common(32),
        score: .median(
            .specific(male: 11.45, female: 12.13),
            dispersion: .specific(male: 2.49, female: 2.36),
            basedOn: .raw(
                positive: [5, 130, 193],
                negative: [39, 46, 58, 64, 80, 88, 95, 98, 131, 145, 154, 191, 207, 233, 241, 242, 263, 270, 271, 272, 285]
            )
        ))


    // MARK: Субъективная депрессия

    /// Субъективная депрессия
    static let d_subjective = AnalysisScale(
        identifier: .d_subjective,
        title: NSLocalizedString("Субъективная депрессия", comment: "Название шкалы"),
        index: .common(33),
        score: .median(
            .specific(male: 9.57, female: 13.59),
            dispersion: .specific(male: 3.15, female: 3.49),
            basedOn: .raw(
                positive: [32, 41, 43, 52, 67, 86, 104, 138, 142, 158, 159, 182, 189, 236, 259],
                negative: [2, 8, 46, 56, 88, 107, 122, 131, 152, 160, 191, 207, 208, 242, 272, 285, 296]
            )
        ))


    // MARK: Психомоторная заторможенность

    /// Психомоторная заторможенность
    static let d_block = AnalysisScale(
        identifier: .d_block,
        title: NSLocalizedString("Психомоторная заторможенность", comment: "Название шкалы"),
        index: .common(34),
        score: .median(
            .specific(male: 5.7, female: 6.52),
            dispersion: .specific(male: 1.84, female: 2.2),
            basedOn: .raw(
                positive: [32, 41, 86, 104, 159, 182, 259, 290],
                negative: [8, 9, 46, 88, 122, 178, 207]
            )
        ))


    // MARK: Мрачность

    /// Мрачность
    static let d_gloom = AnalysisScale(
        identifier: .d_gloom,
        title: NSLocalizedString("Мрачность", comment: "Название шкалы"),
        index: .common(35),
        score: .median(
            .specific(male: 2.65, female: 4.42),
            dispersion: .specific(male: 1.63, female: 1.82),
            basedOn: .raw(
                positive: [41, 67, 104, 138, 142, 158, 182, 236],
                negative: [88, 107]
            )
        ))


    // MARK: Явная депрессия

    /// Явная депрессия
    static let d_evident = AnalysisScale(
        identifier: .d_evident,
        title: NSLocalizedString("Явная депрессия", comment: "Название шкалы"),
        index: .common(36),
        score: .median(
            .specific(male: 9.85, female: 14.48),
            dispersion: .specific(male: 3.66, female: 4.36),
            basedOn: .raw(
                positive: [23, 32, 41, 43, 52, 67, 86, 104, 138, 142, 158, 159, 182, 189, 236, 259, 290],
                negative: [2, 8, 9, 18, 36, 46, 51, 57, 88, 95, 107, 122, 131, 152, 153, 154, 178, 207, 242, 270, 271, 272, 285]
            )
        ))


    // MARK: Депрессивная реакция

    /// Депрессивная реакция
    static let d_reaction = AnalysisScale(
        identifier: .d_reaction,
        title: NSLocalizedString("Депрессивная реакция", comment: "Название шкалы"),
        index: .common(37),
        score: .median(
            .specific(male: 26.22, female: 24.04),
            dispersion: .specific(male: 3.44, female: 3.09),
            basedOn: .raw(
                positive: [51, 55, 95, 128, 130, 162, 232, 236, 255, 294, 376, 380, 399, 414, 509, 519, 521, 563, 565],
                negative: [6, 52, 56, 58, 62, 156, 224, 226, 251, 264, 277, 296, 359, 364, 379, 383, 396, 419, 445, 458, 472, 492, 498]
            )
        ))


    // MARK: Мягкая депрессия

    /// Мягкая депрессия
    static let d_mild = AnalysisScale(
        identifier: .d_mild,
        title: NSLocalizedString("Мягкая депрессия", comment: "Название шкалы"),
        index: .common(38),
        score: .median(
            .specific(male: 11.97, female: 11.59),
            dispersion: .specific(male: 2.69, female: 2.26),
            basedOn: .raw(
                positive: [5, 130, 193],
                negative: [30, 39, 58, 64, 80, 89, 98, 145, 155, 160, 191, 208, 233, 241, 248, 263, 296]
            )
        ))


    // MARK: Истерия

    /// Истерия
    static let hy = AnalysisScale(
        identifier: .hy,
        title: NSLocalizedString("Истерия", comment: "Название шкалы"),
        index: .common(39),
        score: .median(
            .specific(male: 16.48, female: 18.65),
            dispersion: .specific(male: 5.4, female: 5.38),
            basedOn: .raw(
                positive: [10, 23, 32, 43, 44, 47, 76, 114, 179, 186, 189, 238],
                negative: [2, 3, 6, 7, 8, 9, 12, 26, 30, 51, 55, 71, 89, 93, 103, 107, 109, 124, 128, 129, 136, 137, 141, 147, 153, 160, 162, 163, 170, 172, 174, 175, 180, 188, 190, 192, 201, 213, 230, 234, 243, 265, 267, 274, 279, 289, 292]
            )
        ))


    // MARK: Эмоциональная незрелость

    /// Эмоциональная незрелость
    static let hy_immaturity = AnalysisScale(
        identifier: .hy_immaturity,
        title: NSLocalizedString("Эмоциональная незрелость", comment: "Название шкалы"),
        index: .common(40),
        score: .median(
            .specific(male: 12, female: 17.17),
            dispersion: .specific(male: 4.88, female: 5.11),
            basedOn: .raw(
                positive: [13, 21, 24, 32, 43, 52, 76, 94, 97, 106, 109, 118, 182, 189, 222, 238, 247, 248, 266, 301, 305, 322, 335, 345, 526],
                negative: [2, 3, 8, 9, 26, 36, 79, 103, 107, 112, 137, 153, 155, 160, 163, 178, 190, 242, 378, 387, 402, 407, 449]
            )
        ))


    // MARK: Чистая истерия

    /// Чистая истерия
    static let hy_pure = AnalysisScale(
        identifier: .hy_pure,
        title: NSLocalizedString("Чистая истерия", comment: "Название шкалы"),
        index: .common(41),
        score: .median(
            .specific(male: 8.34, female: 8.3),
            dispersion: .specific(male: 2.6, female: 2.12),
            basedOn: .raw(
                positive: [44, 246, 253],
                negative: [6, 12, 26, 71, 123, 129, 136, 147, 162, 172, 174, 213, 234, 265, 279, 292]
            )
        ))


    // MARK: Явная истерия

    /// Явная истерия
    static let hy_evident = AnalysisScale(
        identifier: .hy_evident,
        title: NSLocalizedString("Явная истерия", comment: "Название шкалы"),
        index: .common(42),
        score: .median(
            .specific(male: 4.85, female: 9.34),
            dispersion: .specific(male: 3.54, female: 4.14),
            basedOn: .raw(
                positive: [10, 23, 32, 43, 44, 76, 114, 179, 186, 189, 238],
                negative: [2, 3, 7, 8, 9, 51, 55, 103, 107, 128, 137, 153, 163, 174, 175, 188, 192, 230, 243, 274]
            )
        ))


    // MARK: Скрытая истерия

    /// Скрытая истерия
    static let hy_hidden = AnalysisScale(
        identifier: .hy_hidden,
        title: NSLocalizedString("Скрытая истерия", comment: "Название шкалы"),
        index: .common(43),
        score: .median(
            .specific(male: 13.35, female: 13.35),
            dispersion: .specific(male: 4.27, female: 3.62),
            basedOn: .raw(
                positive: [253],
                negative: [6, 12, 26, 30, 71, 89, 93, 109, 124, 129, 136, 141, 147, 160, 162, 170, 172, 180, 190, 201, 213, 234, 265, 267, 279, 289, 292]
            )
        ))


    // MARK: Эмоциональная чувствительность

    /// Эмоциональная чувствительность
    static let hy_sensitivity = AnalysisScale(
        identifier: .hy_sensitivity,
        title: NSLocalizedString("Эмоциональная чувствительность", comment: "Название шкалы"),
        index: .common(44),
        score: .median(
            .specific(male: 5.3, female: 7.65),
            dispersion: .specific(male: 2.44, female: 2.74),
            basedOn: .raw(
                positive: [134, 217, 226, 239, 278, 282, 299],
                negative: [79, 99, 176, 198, 214, 254, 262, 264]
            )
        ))


    // MARK: Психопатия (Импульсивность)

    /// Психопатия (Импульсивность)
    static let pd = AnalysisScale(
        identifier: .pd,
        title: NSLocalizedString("Психопатия (Импульсивность)", comment: "Название шкалы"),
        index: .common(45),
        score: .median(
            .specific(male: 18.68, female: 18.68),
            dispersion: .specific(male: 4.11, female: 4.11),
            basedOn: 0.4 * .raw_k + .raw(
                positive: [16, 21, 24, 32, 33, 35, 38, 42, 61, 67, 84, 94, 102, 106, 110, 118, 127, 215, 216, 224, 239, 244, 245, 284],
                negative: [26, 8, 20, 37, 82, 91, 96, 107, 134, 137, 141, 155, 170, 171, 173, 180, 183, 201, 231, 235, 237, 248, 267, 287, 289, 294, 296]
            )
        ))


    // MARK: Импульсивность

    /// Импульсивность
    static let pd_impulsiveness = AnalysisScale(
        identifier: .pd_impulsiveness,
        title: NSLocalizedString("Импульсивность", comment: "Название шкалы"),
        index: .common(46),
        score: .median(
            .specific(male: 7.12, female: 8.94),
            dispersion: .specific(male: 3.45, female: 3.16),
            basedOn: .raw(
                positive: [15, 30, 32, 33, 39, 45, 62, 97, 99, 139, 145, 157, 244, 349, 368, 381, 481, 529, 545],
                negative: [96, 111]
            )
        ))


    // MARK: Чистая психопатия

    /// Чистая психопатия
    static let pd_pure = AnalysisScale(
        identifier: .pd_pure,
        title: NSLocalizedString("Чистая психопатия", comment: "Название шкалы"),
        index: .common(47),
        score: .median(
            .specific(male: 6.19, female: 6.77),
            dispersion: .specific(male: 1.98, female: 1.89),
            basedOn: .raw(
                positive: [42, 61, 84, 118, 215, 216, 224, 239, 244, 245],
                negative: [82, 96, 134, 173, 183, 235, 237, 287]
            )
        ))


    // MARK: Явные психопатические отклонения

    /// Явные психопатические отклонения
    static let pd_evident = AnalysisScale(
        identifier: .pd_evident,
        title: NSLocalizedString("Явные психопатические отклонения", comment: "Название шкалы"),
        index: .common(48),
        score: .median(
            .specific(male: 7.02, female: 8.55),
            dispersion: .specific(male: 3.6, female: 3.29),
            basedOn: .raw(
                positive: [16, 24, 32, 33, 35, 38, 42, 61, 67, 84, 94, 106, 110, 118, 215, 216, 224, 244, 245, 284],
                negative: [8, 20, 37, 91, 107, 137, 287, 294]
            )
        ))


    // MARK: Скрытые психопатические отклонения

    /// Скрытые психопатические отклонения
    static let pd_hidden = AnalysisScale(
        identifier: .pd_hidden,
        title: NSLocalizedString("Скрытые психопатические отклонения", comment: "Название шкалы"),
        index: .common(49),
        score: .median(
            .specific(male: 9.48, female: 10.12),
            dispersion: .specific(male: 2.36, female: 2.34),
            basedOn: .raw(
                positive: [21, 102, 127, 239],
                negative: [82, 96, 134, 141, 155, 170, 171, 173, 180, 183, 201, 231, 235, 237, 248, 267, 289, 296]
            )
        ))


    // MARK: Выраженная враждебность

    /// Выраженная враждебность
    static let pd_hostility = AnalysisScale(
        identifier: .pd_hostility,
        title: NSLocalizedString("Выраженная враждебность", comment: "Название шкалы"),
        index: .common(50),
        score: .median(
            .specific(male: 4.32, female: 4.98),
            dispersion: .specific(male: 1.68, female: 1.6),
            basedOn: .raw(
                positive: [27, 43, 59, 89, 108, 167, 189, 208, 350, 507, 520],
                negative: [48, 180, 515]
            )
        ))


    // MARK: Психомоторная акселерация

    /// Психомоторная акселерация
    static let pd_accel = AnalysisScale(
        identifier: .pd_accel,
        title: NSLocalizedString("Психомоторная акселерация", comment: "Название шкалы"),
        index: .common(51),
        score: .median(
            .specific(male: 3.69, female: 3.92),
            dispersion: .specific(male: 1.49, female: 1.62),
            basedOn: .raw(
                positive: [13, 97, 100, 111, 181, 238, 266],
                negative: [119, 134, 228, 268]
            )
        ))


    // MARK: Осознанная выраженная враждебность

    /// Осознанная выраженная враждебность
    static let pd_intended_hostility = AnalysisScale(
        identifier: .pd_intended_hostility,
        title: NSLocalizedString("Осознанная выраженная враждебность", comment: "Название шкалы"),
        index: .common(52),
        score: .median(
            .specific(male: 16.4, female: 17.42),
            dispersion: .specific(male: 6.12, female: 5.59),
            basedOn: .raw(
                positive: [16, 28, 35, 39, 75, 80, 93, 97, 109, 110, 117, 118, 121, 123, 127, 136, 139, 145, 197, 226, 233, 234, 235, 265, 269, 271, 280, 316, 336, 355, 381, 393, 417, 426, 437, 438, 447, 452, 469, 471, 504, 507],
                negative: [82, 96, 347, 399, 468]
            )
        ))


    // MARK: Контроль над враждебностью

    /// Контроль над враждебностью
    static let pd_hostility_control = AnalysisScale(
        identifier: .pd_hostility_control,
        title: NSLocalizedString("Контроль над враждебностью", comment: "Название шкалы"),
        index: .common(53),
        score: .median(
            .specific(male: 7.95, female: 9.67),
            dispersion: .specific(male: 2.86, female: 2.67),
            basedOn: .raw(
                positive: [24, 35, 43, 49, 106, 145, 149, 209, 250, 292, 293, 301, 304, 315, 338, 348, 354, 366, 378, 457, 494, 511, 543, 561],
                negative: [8, 57, 164, 175, 251, 283, 353, 403, 460, 496]
            )
        ))


    // MARK: Подавление агрессии

    /// Подавление агрессии
    static let pd_aggro_suppression = AnalysisScale(
        identifier: .pd_aggro_suppression,
        title: NSLocalizedString("Подавление агрессии", comment: "Название шкалы"),
        index: .common(54),
        score: .median(
            .specific(male: 1.78, female: 2.08),
            dispersion: .specific(male: 1.11, female: 1.1),
            basedOn: .raw(
                positive: [],
                negative: [6, 12, 30, 128, 129, 147, 170]
            )
        ))


    // MARK: Половое развитие

    /// Половое развитие
    static let mf = AnalysisScale(
        identifier: .mf,
        title: NSLocalizedString("Половое развитие", comment: "Название шкалы"),
        index: .specific(male: 60, female: 55),
        score: .median(
            .specific(male: 20.46, female: 36.7),
            dispersion: .specific(male: 5, female: 4.67),
            inverted: .specific(male: false, female: true),
            basedOn: .raw(
                .specific(
                    male: (
                        positive: [4, 25, 26, 69, 70, 74, 77, 78, 87, 92, 126, 132, 134, 140, 149, 179, 187, 203, 204, 217, 226, 231, 239, 261, 278, 282, 295, 297, 299],
                        negative: [1, 19, 28, 79, 80, 81, 89, 99, 112, 115, 116, 117, 120, 133, 144, 176, 198, 213, 214, 219, 221, 223, 229, 249, 254, 260, 262, 264, 280, 283, 300]
                    ),
                    female: (
                        positive: [4, 25, 70, 74, 77, 78, 87, 92, 126, 132, 133, 134, 140, 149, 187, 203, 204, 217, 226, 239, 261, 278, 282, 295, 299],
                        negative: [1, 19, 26, 28, 69, 79, 80, 81, 89, 99, 112, 115, 116, 117, 120, 144, 176, 179, 198, 213, 214, 219, 221, 223, 229, 231, 249, 254, 260, 262, 264, 280, 283, 297, 300]
                    )
                )
            )
        ))


    // MARK: Женственность

    /// Женственность
    static let mf_femininity = AnalysisScale(
        identifier: .mf_femininity,
        title: NSLocalizedString("Женственность", comment: "Название шкалы"),
        index: .common(56),
        score: .median(
            .specific(male: 6.03, female: 9),
            dispersion: .specific(male: 1.97, female: 2.24),
            basedOn: .raw(
                positive: [4, 92, 203, 361, 392, 545, 555],
                negative: [1, 99, 118, 144, 145, 219, 223, 254, 563]
            )
        ))


    // MARK: Женственность интересов

    /// Женственность интересов
    static let mf_feminine_values = AnalysisScale(
        identifier: .mf_feminine_values,
        title: NSLocalizedString("Женственность интересов", comment: "Название шкалы"),
        index: .common(57),
        score: .brackets(
            .specific(
                male: (20, 26, 46, 55),
                female: (41, 47, 66, 74)
            ),
            basedOn: .rawPercentage(
                positive: [4, 25, 70, 77, 78, 87, 92, 126, 132, 140, 149, 203, 204, 261, 295, 69, 74, 187],
                negative: [1, 19, 28, 79, 81, 112, 115, 116, 133, 144, 176, 198, 214, 219, 221, 223, 249, 260, 264, 280, 283, 300]
            )
        ))


    // MARK: Ригидность

    /// Ригидность
    static let mf_rigidness = AnalysisScale(
        identifier: .mf_rigidness,
        title: NSLocalizedString("Ригидность", comment: "Название шкалы"),
        index: .specific(male: 61, female: 58),
        score: .median(
            .specific(male: 5.32, female: 5.26),
            dispersion: .specific(male: 1.33, female: 1.52),
            basedOn: .raw(
                .specific(
                    male: (
                        positive: [37, 86, 111, 141, 304, 342, 357],
                        negative: [215, 216, 298]
                    ),
                    female: (
                        positive: [86, 96, 304, 321, 344, 349],
                        negative: [21, 157, 181, 216]
                    )
                )
            )
        ))


    // MARK: Стабильность профиля (Уравновешенность)

    /// Стабильность профиля (Уравновешенность)
    static let mf_stability = AnalysisScale(
        identifier: .mf_stability,
        title: NSLocalizedString("Стабильность профиля (Уравновешенность)", comment: "Название шкалы"),
        index: .specific(male: 62, female: 59),
        score: .median(
            .specific(male: 18.14, female: 13.63),
            dispersion: .specific(male: 4.18, female: 2.66),
            basedOn: .raw(
                .specific(
                    male: (
                        positive: [99, 170, 428],
                        negative: [40, 86, 97, 100, 102, 119, 138, 143, 149, 232, 238, 263, 268, 278, 282, 298, 299, 307, 317, 348, 358, 359, 361, 426, 472, 475, 490, 558]
                    ),
                    female: (
                        positive: [7, 171, 321, 324, 522],
                        negative: [15, 36, 59, 69, 77, 112, 131, 241, 243, 253, 283, 357, 373, 402, 429, 478, 481, 502, 503, 516, 537, 551]
                    )
                )
            )
        ))


    // MARK: Паранойя (Ригидность)

    /// Паранойя (Ригидность)
    static let pa = AnalysisScale(
        identifier: .pa,
        title: NSLocalizedString("Паранойя (Ригидность)", comment: "Название шкалы"),
        index: .common(63),
        score: .median(
            7.9,
            dispersion: 3.4,
            basedOn: .raw(
                positive: [15, 16, 22, 24, 27, 35, 110, 121, 123, 127, 151, 157, 158, 202, 275, 284, 291, 293, 299, 305, 317, 338, 341, 364, 365],
                negative: [93, 107, 109, 111, 117, 124, 268, 281, 294, 313, 316, 319, 327, 347, 348]
            )
        ))


    // MARK: Чистая паранойя

    /// Чистая паранойя
    static let pa_pure = AnalysisScale(
        identifier: .pa_pure,
        title: NSLocalizedString("Чистая паранойя", comment: "Название шкалы"),
        index: .common(64),
        score: .median(
            .specific(male: 4.61, female: 4.9),
            dispersion: .common(1.64),
            basedOn: .raw(
                positive: [27, 123, 151, 275, 293, 338, 365],
                negative: [117, 268, 313, 316, 319, 327, 347, 348]
            )
        ))


    // MARK: Идеи преследования

    /// Идеи преследования
    static let pa_stalking = AnalysisScale(
        identifier: .pa_stalking,
        title: NSLocalizedString("Идеи преследования", comment: "Название шкалы"),
        index: .common(65),
        score: .median(
            .specific(male: 2.74, female: 3.31),
            dispersion: .specific(male: 2.25, female: 2.03),
            basedOn: .raw(
                positive: [16, 24, 35, 110, 121, 123, 127, 151, 157, 202, 275, 284, 291, 293, 338, 364],
                negative: [347]
            )
        ))


    // MARK: Идеи отравления

    /// Идеи отравления
    static let pa_poisoning = AnalysisScale(
        identifier: .pa_poisoning,
        title: NSLocalizedString("Идеи отравления", comment: "Название шкалы"),
        index: .common(66),
        score: .median(
            .specific(male: 1.96, female: 3.59),
            dispersion: .specific(male: 1.46, female: 1.8),
            basedOn: .raw(
                positive: [24, 111, 158, 299, 305, 317, 341, 365],
                negative: [268]
            )
        ))


    // MARK: Явная паранойя

    /// Явная паранойя
    static let pa_evident = AnalysisScale(
        identifier: .pa_evident,
        title: NSLocalizedString("Явная паранойя", comment: "Название шкалы"),
        index: .common(67),
        score: .median(
            .specific(male: 3.5, female: 5.24),
            dispersion: .specific(male: 2.7, female: 2.73),
            basedOn: .raw(
                positive: [16, 24, 27, 35, 110, 121, 123, 151, 158, 202, 275, 284, 291, 293, 305, 317, 326, 338, 341, 364],
                negative: [281, 294, 347]
            )
        ))


    // MARK: Скрытая паранойя

    /// Скрытая паранойя
    static let pa_hidden = AnalysisScale(
        identifier: .pa_hidden,
        title: NSLocalizedString("Скрытая паранойя", comment: "Название шкалы"),
        index: .common(68),
        score: .median(
            .specific(male: 7.36, female: 7.62),
            dispersion: .specific(male: 2.24, female: 2.01),
            basedOn: .raw(
                positive: [15, 127, 157, 299, 365],
                negative: [93, 107, 109, 111, 117, 124, 268, 313, 316, 319, 327, 348]
            )
        ))


    // MARK: Фактор паранойи

    /// Фактор паранойи
    static let pa_factor = AnalysisScale(
        identifier: .pa_factor,
        title: NSLocalizedString("Фактор паранойи", comment: "Название шкалы"),
        index: .common(69),
        score: .median(
            .specific(male: 2.14, female: 2.71),
            dispersion: .specific(male: 1.89, female: 1.71),
            basedOn: .raw(
                positive: [16, 24, 35, 110, 121, 123, 157, 202, 245, 275, 284, 291, 293, 364],
                negative: []
            )
        ))


    // MARK: Комплекс осуждения (комплекс вины)

    /// Комплекс осуждения (комплекс вины)
    static let pa_guilt = AnalysisScale(
        identifier: .pa_guilt,
        title: NSLocalizedString("Комплекс осуждения (комплекс вины)", comment: "Название шкалы"),
        index: .common(70),
        score: .median(
            .specific(male: 27, female: 28.66),
            dispersion: .specific(male: 3.42, female: 3.81),
            basedOn: .raw(
                positive: [4, 18, 77, 78, 91, 97, 126, 132, 148, 149, 176, 180, 203, 204, 237, 239, 277, 295, 299, 306],
                negative: [19, 20, 26, 28, 41, 79, 84, 94, 99, 118, 133, 144, 157, 216, 224, 227, 232, 260, 264, 279, 283, 297, 300, 303, 310, 316, 338, 343, 356, 358]
            )
        ))


    // MARK: Психастения (Тревожность)

    /// Психастения (Тревожность)
    static let pf = AnalysisScale(
        identifier: .pf,
        title: NSLocalizedString("Психастения (Тревожность)", comment: "Название шкалы"),
        index: .common(71),
        score: .median(
            .specific(male: 23.05, female: 25.07),
            dispersion: .specific(male: 5, female: 6.1),
            basedOn: .raw_k + .raw(
                positive: [10, 15, 22, 32, 41, 67, 76, 86, 94, 102, 106, 142, 159, 182, 189, 217, 238, 266, 301, 304, 305, 317, 321, 336, 337, 340, 342, 343, 344, 346, 349, 351, 352, 356, 357, 359, 360, 361],
                negative: [3, 8, 36, 122, 152, 164, 178, 329, 353]
            )
        ))


    // MARK: Реакция тревоги

    /// Реакция тревоги
    static let pf_anxiety_reaction = AnalysisScale(
        identifier: .pf_anxiety_reaction,
        title: NSLocalizedString("Реакция тревоги", comment: "Название шкалы"),
        index: .common(72),
        score: .median(
            .specific(male: 23.55, female: 24.94),
            dispersion: .specific(male: 2.92, female: 3.13),
            basedOn: .raw(
                positive: [1, 47, 71, 96, 111, 115, 129, 171, 191, 249, 263, 336, 340, 347, 351, 356, 392, 439, 460, 483, 548],
                negative: [2, 3, 4, 75, 77, 87, 89, 99, 152, 167, 168, 203, 215, 251, 275, 320, 334, 407, 412, 456, 475, 482, 546, 547, 557]
            )
        ))


    // MARK: Тревога

    /// Тревога
    static let pf_anxiety = AnalysisScale(
        identifier: .pf_anxiety,
        title: NSLocalizedString("Тревога", comment: "Название шкалы"),
        index: .common(73),
        score: .median(
            .specific(male: 12.89, female: 20.81),
            dispersion: .specific(male: 6.38, female: 6.46),
            basedOn: .raw(
                positive: [13, 14, 23, 31, 32, 43, 67, 86, 125, 142, 158, 186, 191, 217, 238, 241, 263, 301, 317, 321, 322, 335, 337, 340, 352, 361, 371, 397, 418, 424, 431, 439, 442, 499, 506, 530, 549, 555],
                negative: [7, 18, 107, 163, 190, 230, 242, 264, 287, 407, 523, 528]
            )
        ))


    // MARK: Вытеснение тревоги

    /// Вытеснение тревоги
    static let pf_anxiety_repression = AnalysisScale(
        identifier: .pf_anxiety_repression,
        title: NSLocalizedString("Вытеснение тревоги", comment: "Название шкалы"),
        index: .common(74),
        score: .median(
            .specific(male: 3.09, female: 3.04),
            dispersion: .specific(male: 1.62, female: 1.67),
            basedOn: .raw(
                positive: [],
                negative: [141, 172, 180, 201, 267, 292]
            )
        ))


    // MARK: Осознанная тревога

    /// Осознанная тревога
    static let pf_realized_anxiety = AnalysisScale(
        identifier: .pf_realized_anxiety,
        title: NSLocalizedString("Осознанная тревога", comment: "Название шкалы"),
        index: .common(75),
        score: .median(
            .specific(male: 6, female: 9.96),
            dispersion: .specific(male: 3.98, female: 4.68),
            basedOn: .raw(
                positive: [5, 10, 13, 14, 23, 31, 32, 43, 72, 179, 186, 191, 217, 238, 301, 321, 335, 337, 351, 360, 365, 395, 431, 439, 480, 494, 499, 506, 543, 555, 559],
                negative: []
            )
        ))


    // MARK: Шизофрения (индивидуалистичность)

    /// Шизофрения (индивидуалистичность)
    static let sc = AnalysisScale(
        identifier: .sc,
        title: NSLocalizedString("Шизофрения (индивидуалистичность)", comment: "Название шкалы"),
        index: .common(76),
        score: .median(
            .specific(male: 21.96, female: 22.73),
            dispersion: .specific(male: 5, female: 6.36),
            basedOn: .raw_k + .raw(
                positive: [15, 16, 21, 22, 24, 32, 33, 35, 38, 40, 41, 47, 52, 76, 97, 104, 121, 156, 157, 159, 168, 179, 182, 194, 202, 210, 212, 238, 241, 251, 259, 266, 273, 282, 291, 297, 301, 303, 305, 307, 312, 320, 324, 325, 332, 334, 335, 339, 341, 345, 349, 350, 352, 354, 355, 356, 360, 363, 364],
                negative: [8, 17, 20, 37, 65, 103, 119, 177, 178, 187, 192, 196, 220, 276, 281, 306, 309, 322, 330]
            )
        ))


    // MARK: Оригинальность

    /// Оригинальность
    static let sc_originality = AnalysisScale(
        identifier: .sc_originality,
        title: NSLocalizedString("Оригинальность", comment: "Название шкалы"),
        index: .common(77),
        score: .median(
            .specific(male: 12, female: 12.8),
            dispersion: .specific(male: 2.67, female: 2.63),
            basedOn: .raw(
                positive: [148, 364, 408, 432],
                negative: [67, 82, 112, 115, 129, 136, 138, 206, 219, 223, 258, 268, 322, 394, 406, 411, 498, 523, 561, 563, 564]
            )
        ))


    // MARK: Прогноз шизофрении

    /// Прогноз шизофрении
    static let sc_prognosis = AnalysisScale(
        identifier: .sc_prognosis,
        title: NSLocalizedString("Прогноз шизофрении", comment: "Название шкалы"),
        index: .common(78),
        score: .median(
            .specific(male: 32.35, female: 32.39),
            dispersion: .specific(male: 3.7, female: 3.78),
            basedOn: .raw(
                positive: [18, 32, 86, 90, 142, 150, 155, 158, 168, 174, 176, 182, 200, 236, 260, 285, 294, 306, 308, 335, 339, 342, 396, 422, 429, 464, 491],
                negative: [4, 8, 11, 53, 109, 132, 147, 178, 180, 224, 233, 234, 268, 270, 283, 327, 343, 346, 360, 364, 367, 370, 373, 375, 400, 404, 419, 426, 440, 484, 485, 488, 490, 492, 522, 525, 541, 551]
            )
        ))


    // MARK: Параноидная шизофрения

    /// Параноидная шизофрения
    static let sc_paranoid = AnalysisScale(
        identifier: .sc_paranoid,
        title: NSLocalizedString("Параноидная шизофрения", comment: "Название шкалы"),
        index: .common(79),
        score: .median(
            .specific(male: 14.87, female: 17.58),
            dispersion: .specific(male: 5.82, female: 5.81),
            basedOn: .raw(
                positive: [2, 4, 11, 24, 27, 35, 48, 49, 51, 66, 108, 110, 121, 123, 134, 139, 157, 161, 172, 179, 182, 194, 197, 200, 202, 212, 252, 260, 274, 275, 284, 286, 291, 293, 334, 349, 350, 360, 364, 377, 386, 435, 448, 453, 454, 469, 509, 519, 525, 551, 553],
                negative: [20, 133, 177, 198, 220, 254, 309, 347, 369, 446, 462, 464, 496]
            )
        ))


    // MARK: Чистая шизофрения

    /// Чистая шизофрения
    static let sc_pure = AnalysisScale(
        identifier: .sc_pure,
        title: NSLocalizedString("Чистая шизофрения", comment: "Название шкалы"),
        index: .common(80),
        score: .median(
            .specific(male: 5.17, female: 6.61),
            dispersion: .specific(male: 2.95, female: 3.05),
            basedOn: .raw(
                positive: [40, 168, 210, 241, 282, 297, 303, 307, 312, 320, 324, 325, 334, 339, 345, 350, 354, 355, 363, 335],
                negative: [17, 65, 177, 187, 196, 220, 276, 306, 323, 330]
            )
        ))


    // MARK: Причудливость сенсорного восприятия

    /// Причудливость сенсорного восприятия
    static let sc_sensoric = AnalysisScale(
        identifier: .sc_sensoric,
        title: NSLocalizedString("Причудливость сенсорного восприятия", comment: "Название шкалы"),
        index: .common(81),
        score: .median(
            .specific(male: 2.26, female: 3.66),
            dispersion: .specific(male: 2.23, female: 2.58),
            basedOn: .raw(
                positive: [22, 33, 47, 156, 194, 210, 251, 273, 291, 332, 334, 341, 345, 350],
                negative: [103, 119, 187, 192, 281, 330]
            )
        ))


    // MARK: Эмоциональное отчуждение

    /// Эмоциональное отчуждение
    static let sc_emotional = AnalysisScale(
        identifier: .sc_emotional,
        title: NSLocalizedString("Эмоциональное отчуждение", comment: "Название шкалы"),
        index: .common(82),
        score: .median(
            .specific(male: 2.36, female: 2.71),
            dispersion: .specific(male: 1.09, female: 1.38),
            basedOn: .raw(
                positive: [76, 104, 202, 301, 339, 360, 363],
                negative: [81, 96, 322, 355]
            )
        ))


    // MARK: Гипомания (оптимистичность)

    /// Гипомания (оптимистичность)
    static let ma = AnalysisScale(
        identifier: .ma,
        title: NSLocalizedString("Гипомания (оптимистичность)", comment: "Название шкалы"),
        index: .common(83),
        score: .median(
            17,
            dispersion: 4.06,
            basedOn: 0.2 * .raw_k + .raw(
                positive: [11, 13, 21, 22, 59, 64, 73, 97, 100, 109, 127, 134, 143, 156, 157, 167, 181, 194, 212, 222, 226, 228, 232, 233, 238, 240, 250, 251, 263, 266, 268, 271, 277, 279, 298],
                negative: [101, 105, 111, 119, 120, 148, 166, 171, 180, 267, 289]
            )
        ))


    // MARK: Чистая гипомания

    /// Чистая гипомания
    static let ma_pure = AnalysisScale(
        identifier: .ma_pure,
        title: NSLocalizedString("Чистая гипомания", comment: "Название шкалы"),
        index: .common(84),
        score: .median(
            .specific(male: 12.12, female: 11.97),
            dispersion: .specific(male: 2.97, female: 2.88),
            basedOn: .raw(
                positive: [11, 59, 64, 73, 100, 109, 134, 143, 167, 181, 222, 226, 228, 232, 233, 240, 250, 263, 271, 277, 279, 298],
                negative: [101, 105, 148, 166]
            )
        ))


    // MARK: Явная гипомания

    /// Явная гипомания
    static let ma_evident = AnalysisScale(
        identifier: .ma_evident,
        title: NSLocalizedString("Явная гипомания", comment: "Название шкалы"),
        index: .common(85),
        score: .median(
            .specific(male: 5.7, female: 7.08),
            dispersion: .specific(male: 3.02, female: 2.91),
            basedOn: .raw(
                positive: [13, 22, 59, 73, 97, 100, 156, 157, 167, 194, 212, 226, 238, 250, 251, 263, 266, 277, 279, 298],
                negative: [111, 119, 120]
            )
        ))


    // MARK: Скрытая гипомания

    /// Скрытая гипомания
    static let ma_hidden = AnalysisScale(
        identifier: .ma_hidden,
        title: NSLocalizedString("Скрытая гипомания", comment: "Название шкалы"),
        index: .common(86),
        score: .median(
            .specific(male: 11.48, female: 10.88),
            dispersion: .specific(male: 2.47, female: 2.72),
            basedOn: .raw(
                positive: [11, 21, 64, 109, 127, 134, 143, 181, 222, 228, 232, 233, 240, 268, 271],
                negative: [101, 105, 148, 166, 171, 180, 267, 289]
            )
        ))


    // MARK: Интраверсия

    /// Интраверсия
    static let si = AnalysisScale(
        identifier: .si,
        title: NSLocalizedString("Интраверсия", comment: "Название шкалы"),
        index: .common(87),
        score: .median(
            25,
            dispersion: 10,
            basedOn: .raw(
                positive: [32, 67, 82, 111, 117, 124, 138, 147, 171, 172, 180, 201, 236, 267, 278, 292, 304, 316, 321, 332, 336, 342, 357, 377, 383, 398, 411, 427, 436, 455, 473, 487, 549, 564],
                negative: [25, 33, 57, 91, 99, 119, 126, 143, 193, 208, 229, 231, 254, 262, 281, 296, 309, 353, 359, 371, 391, 400, 415, 440, 446, 449, 450, 451, 462, 469, 479, 481, 482, 505, 521, 547]
            )
        ))


    // MARK: 1-й фактор А

    /// 1-й фактор А
    static let fa1 = AnalysisScale(
        identifier: .fa1,
        title: NSLocalizedString("1-й фактор А", comment: "Название шкалы"),
        index: .common(88),
        score: .median(
            .specific(male: 11, female: 16.48),
            dispersion: .specific(male: 6.52, female: 6.94),
            basedOn: .raw(
                positive: [32, 41, 76, 67, 94, 138, 147, 236, 259, 267, 278, 301, 305, 321, 337, 343, 344, 345, 356, 359, 374, 382, 383, 384, 389, 396, 397, 411, 414, 418, 431, 443, 465, 499, 511, 518, 544, 555],
                negative: [379]
            )
        ))


    // MARK: 2-й фактор R

    /// 2-й фактор R
    static let fr2 = AnalysisScale(
        identifier: .fr2,
        title: NSLocalizedString("2-й фактор R", comment: "Название шкалы"),
        index: .common(89),
        score: .median(
            .specific(male: 16.8, female: 17.05),
            dispersion: .specific(male: 4.04, female: 3.55),
            basedOn: .raw(
                positive: [],
                negative: [1, 6, 9, 12, 39, 51, 81, 112, 126, 131, 140, 145, 154, 156, 191, 208, 219, 221, 271, 272, 281, 282, 327, 406, 415, 429, 440, 445, 447, 449, 450, 451, 462, 468, 472, 502, 516, 529, 550, 556]
            )
        ))


    // MARK: Невротизм

    /// Невротизм
    static let ne = AnalysisScale(
        identifier: .ne,
        title: NSLocalizedString("Невротизм", comment: "Название шкалы"),
        index: .common(90),
        score: .median(
            .specific(male: 4.79, female: 7.96),
            dispersion: .specific(male: 3.14, female: 3.78),
            basedOn: .raw(
                positive: [5, 29, 41, 43, 44, 47, 72, 76, 108, 114, 159, 186, 189, 191, 236, 238, 263],
                negative: [2, 3, 9, 46, 51, 68, 103, 107, 175, 178, 190, 208, 242]
            )
        ))


    // MARK: Психоневроз

    /// Психоневроз
    static let pne = AnalysisScale(
        identifier: .pne,
        title: NSLocalizedString("Психоневроз", comment: "Название шкалы"),
        index: .common(91),
        score: .median(
            .specific(male: 11.22, female: 15.06),
            dispersion: .specific(male: 4.56, female: 4.88),
            basedOn: .raw(
                positive: [102, 105, 120, 129, 133, 147, 148, 161, 172, 296, 344, 348, 359, 374, 382, 389, 390, 396, 398, 408, 416, 468, 499],
                negative: [63, 68, 119, 130, 160, 163, 214, 264, 274, 367]
            )
        ))


    // MARK: Оценка улучшения

    /// Оценка улучшения
    static let ie = AnalysisScale(
        identifier: .ie,
        title: NSLocalizedString("Оценка улучшения", comment: "Название шкалы"),
        index: .common(92),
        score: .median(
            .specific(male: 16.06, female: 24.7),
            dispersion: .specific(male: 8.06, female: 8.98),
            basedOn: .raw(
                positive: [13, 32, 43, 48, 61, 62, 67, 76, 84, 86, 94, 102, 104, 106, 114, 142, 180, 189, 217, 236, 244, 267, 301, 305, 317, 335, 337, 338, 343, 345, 349, 356, 361, 374, 377, 384, 395, 397, 414, 431, 448, 487, 526, 543, 544, 555, 559],
                negative: [3, 8, 9, 57, 107, 152, 198, 242, 287, 371, 379, 407, 449, 520, 547]
            )
        ))


    // MARK: Предсказание изменений

    /// Предсказание изменений
    static let cp = AnalysisScale(
        identifier: .cp,
        title: NSLocalizedString("Предсказание изменений", comment: "Название шкалы"),
        index: .common(93),
        score: .median(
            .specific(male: 4.4, female: 7.52),
            dispersion: .specific(male: 2.57, female: 3.01),
            basedOn: .raw(
                positive: [10, 32, 43, 47, 72, 76, 108, 125, 238, 266, 273, 303, 337, 388, 526],
                negative: [2, 12, 51, 55, 155, 175, 243, 521, 533]
            )
        ))


    // MARK: Рецидивизм

    /// Рецидивизм
    static let re = AnalysisScale(
        identifier: .re,
        title: NSLocalizedString("Рецидивизм", comment: "Название шкалы"),
        index: .common(94),
        score: .median(
            .specific(male: 9.22, female: 9.27),
            dispersion: .specific(male: 2.7, female: 2.73),
            basedOn: .raw(
                positive: [41, 64, 80, 81, 102, 109, 118, 127, 215, 219, 233, 240, 437, 459],
                negative: [62, 111, 120, 249, 278, 294, 370, 440, 460, 513]
            )
        ))



    // MARK: - Г. ИНТЕЛЛЕКТ

    /// Г. ИНТЕЛЛЕКТ
    static let group_intelligence = AnalysisScale.dummy(
        identifier: .group_intelligence,
        title: NSLocalizedString("Г. ИНТЕЛЛЕКТ", comment: "Название группы шкал")
    )


    // MARK: Творческий склад

    /// Творческий склад
    static let i95 = AnalysisScale(
        identifier: .i95,
        title: NSLocalizedString("Творческий склад", comment: "Название шкалы"),
        index: .common(95),
        score: .brackets(
            .specific(
                male: (16, 18, 25, 29),
                female: (18, 20, 28, 31)
            ),
            upperBracketMode: .saturate,
            basedOn: trunc(100.0 * .rawPercentage_i95 / .taer)
        ))


    // MARK: Эрудиционный склад

    /// Эрудиционный склад
    static let i96 = AnalysisScale(
        identifier: .i96,
        title: NSLocalizedString("Эрудиционный склад", comment: "Название шкалы"),
        index: .common(96),
        score: .brackets(
            .specific(
                male: (21, 23, 28, 30),
                female: (20, 22, 26, 28)
            ),
            upperBracketMode: .saturate,
            basedOn: trunc(100.0 * .rawPercentage_i96 / .taer)
        ))


    // MARK: Рутинность

    /// Рутинность
    static let i97 = AnalysisScale(
        identifier: .i97,
        title: NSLocalizedString("Рутинность", comment: "Название шкалы"),
        index: .common(97),
        score: .brackets(
            .specific(
                male: (18, 20, 25, 27),
                female: (20, 22, 26, 28)
            ),
            upperBracketMode: .saturate,
            basedOn: trunc(100.0 * .rawPercentage_i97 / .taer)
        ))


    // MARK: Интеллектуальная активность

    /// Интеллектуальная активность
    static let i98 = AnalysisScale(
        identifier: .i98,
        title: NSLocalizedString("Интеллектуальная активность", comment: "Название шкалы"),
        index: .common(98),
        score: .brackets(
            .specific(
                male: (23, 26, 34, 37),
                female: (23, 26, 34, 37)
            ),
            upperBracketMode: .saturate,
            basedOn: trunc(100.0 * .rawPercentage_i98 / .taer)
        ))


    // MARK: Интеллектуальный показатель

    /// Интеллектуальный показатель
    static let i99 = AnalysisScale(
        identifier: .i99,
        title: NSLocalizedString("Интеллектуальный показатель", comment: "Название шкалы"),
        index: .common(99),
        score: .brackets(
            (41, 44, 51, 53),
            upperBracketMode: .saturate,
            basedOn: .raw_i99
        ))


    // MARK: Научный потенциал

    /// Научный потенциал
    static let i100 = AnalysisScale(
        identifier: .i100,
        title: NSLocalizedString("Научный потенциал", comment: "Название шкалы"),
        index: .common(100),
        score: .potential(.scientific)
    )


    // MARK: Артистический потенциал

    /// Артистический потенциал
    static let i101 = AnalysisScale(
        identifier: .i101,
        title: NSLocalizedString("Артистический потенциал", comment: "Название шкалы"),
        index: .common(101),
        score: .potential(.artistic)
    )


    // MARK: Религиозный потенциал

    /// Религиозный потенциал
    static let i102 = AnalysisScale(
        identifier: .i102,
        title: NSLocalizedString("Религиозный потенциал", comment: "Название шкалы"),
        index: .common(102),
        score: .potential(.religious)
    )


    // MARK: Интеллектуальная продуктивность

    /// Интеллектуальная продуктивность
    static let i103 = AnalysisScale(
        identifier: .i103,
        title: NSLocalizedString("Интеллектуальная продуктивность", comment: "Название шкалы"),
        index: .common(103),
        score: .brackets(
            (117, 127, 154, 163),
            upperBracketMode: .saturate,
            basedOn: trunc(10.0 * .raw_i99 * .rawPercentage_i98 / .taer)
        ))


    // MARK: Творческая продуктивность

    /// Творческая продуктивность
    static let i104 = AnalysisScale(
        identifier: .i104,
        title: NSLocalizedString("Творческая продуктивность", comment: "Название шкалы"),
        index: .common(104),
        score: .brackets(
            (52, 58, 77, 84),
            upperBracketMode: .saturate,
            basedOn: trunc(10.0 * trunc(100.0 * .rawPercentage_i95 / .taer) * .rawPercentage_i98  / .taer)
        ))


    // MARK: Интеллектуальная эффективность

    /// Интеллектуальная эффективность
    static let i105 = AnalysisScale(
        identifier: .i105,
        title: NSLocalizedString("Интеллектуальная эффективность", comment: "Название шкалы"),
        index: .common(105),
        score: .median(
            .specific(male: 28.67, female: 27.14),
            dispersion: .specific(male: 3.75, female: 3.14),
            basedOn: .raw(
                positive: [36, 37, 60, 63, 78, 122, 221, 225, 277, 462, 464, 521, 524, 546, 552],
                negative: [13, 28, 33, 35, 62, 116, 146, 194, 198, 224, 256, 260, 267, 280, 304, 338, 392, 448, 455, 487, 492, 526, 541, 559]
            )
        ))


    // MARK: Интеллектуальный коэффициент

    /// Интеллектуальный коэффициент
    static let i106 = AnalysisScale(
        identifier: .i106,
        title: NSLocalizedString("Интеллектуальный коэффициент", comment: "Название шкалы"),
        index: .common(106),
        score: .median(
            .specific(male: 42.25, female: 39.83),
            dispersion: .common(5.48),
            basedOn: .raw(
                positive: [36, 37, 60, 63, 78, 122, 173, 221, 225, 277, 281, 289, 430, 460, 462, 464, 496, 521, 524, 546, 552],
                negative: [13, 28, 33, 35, 62, 111, 116, 117, 146, 194, 198, 224, 250, 256, 260, 265, 267, 280, 304, 313, 338, 343, 348, 392, 442, 448, 455, 480, 485, 487, 492, 504, 511, 526, 541, 553, 555, 559]
            )
        ))


    // MARK: Психологические интересы

    /// Психологические интересы
    static let i107 = AnalysisScale(
        identifier: .i107,
        title: NSLocalizedString("Психологические интересы", comment: "Название шкалы"),
        index: .common(107),
        score: .median(
            .specific(male: 4.26, female: 3.84),
            dispersion: .specific(male: 1.22, female: 1.36),
            basedOn: .raw(
                positive: [176, 225],
                negative: [32, 335, 531, 558]
            )
        ))



    // MARK: - Д. ТРУДОВЫЕ КАЧЕСТВА

    /// Д. ТРУДОВЫЕ КАЧЕСТВА
    static let group_work = AnalysisScale.dummy(
        identifier: .group_work,
        title: NSLocalizedString("Д. ТРУДОВЫЕ КАЧЕСТВА", comment: "Название группы шкал")
    )


    // MARK: Способность к обучению

    /// Способность к обучению
    static let educability = AnalysisScale(
        identifier: .educability,
        title: NSLocalizedString("Способность к обучению", comment: "Название шкалы"),
        index: .common(108),
        score: .median(
            .specific(male: 13.1, female: 11.9),
            dispersion: .specific(male: 2.91, female: 2.78),
            basedOn: .raw(
                positive: [3, 295, 415, 546],
                negative: [28, 33, 104, 118, 142, 146, 224, 244, 251, 260, 303, 381, 386, 419]
            )
        ))


    // MARK: Работоспособность (отношение к работе)

    /// Работоспособность (отношение к работе)
    static let working_capacity = AnalysisScale(
        identifier: .working_capacity,
        title: NSLocalizedString("Работоспособность (отношение к работе)", comment: "Название шкалы"),
        index: .common(109),
        score: .median(
            .specific(male: 11.67, female: 14.66),
            dispersion: .specific(male: 3.92, female: 4.22),
            basedOn: .raw(
                positive: [13, 16, 32, 35, 40, 41, 59, 84, 109, 112, 170, 244, 250, 259, 272, 301, 312, 331, 335, 343, 389, 395, 404, 406, 435, 487, 507, 526, 549],
                negative: [3, 9, 88, 164, 207, 257, 318, 407]
            )
        ))


    // MARK: Школьный потенциал

    /// Школьный потенциал
    static let student_potential = AnalysisScale(
        identifier: .student_potential,
        title: NSLocalizedString("Школьный потенциал", comment: "Название шкалы"),
        index: .common(110),
        score: .brackets(
            .specific(
                male: (37, 48, 73, 79),
                female: (37, 48, 73, 79)
            ),
            basedOn: .rawPercentage(
                positive: [176, 225, 432],
                negative: [32, 33, 67, 335, 389, 418, 431, 456, 475, 531, 557]
            )
        ))


    // MARK: Преподавательский потенциал

    /// Преподавательский потенциал
    static let teacher_potential = AnalysisScale(
        identifier: .teacher_potential,
        title: NSLocalizedString("Преподавательский потенциал", comment: "Название шкалы"),
        index: .common(111),
        score: .median(
            .specific(male: 70.7, female: 60.39),
            dispersion: .specific(male: 12.12, female: 12.3),
            basedOn: .raw(
                positive: [57, 65, 107, 119, 137, 152, 163, 188, 230, 257, 274, 309, 310, 371, 407, 412, 487, 527],
                negative: [11, 26, 32, 40, 52, 67, 82, 86, 136, 142, 147, 157, 186, 212, 216, 224, 236, 238, 244, 250, 252, 259, 260, 267, 271, 278, 280, 282, 284, 290, 297, 298, 301, 305, 314, 317, 319, 320, 327, 328, 332, 335, 338, 342, 343, 344, 345, 348, 352, 356, 366, 368, 374, 377, 381, 382, 385, 389, 395, 396, 397, 402, 404, 411, 418, 448, 456, 465, 484, 485, 505, 506, 509, 511, 516, 531, 541, 544, 558, 560]
            )
        ))


    // MARK: Адвокатский тип личности

    /// Адвокатский тип личности
    static let lawyer_personality = AnalysisScale(
        identifier: .lawyer_personality,
        title: NSLocalizedString("Адвокатский тип личности", comment: "Название шкалы"),
        index: .common(112),
        score: .median(
            .specific(male: 30.6, female: 27.88),
            dispersion: .specific(male: 6.27, female: 5.96),
            basedOn: .raw(
                positive: [45, 105, 160, 195, 198, 237, 255, 442],
                negative: [32, 33, 71, 81, 94, 112, 128, 124, 129, 136, 142, 217, 223, 238, 241, 244, 248, 250, 258, 271, 278, 280, 292, 319, 324, 348, 359, 378, 383, 386, 390, 395, 396, 404, 408, 409, 416, 418, 447, 461, 468, 504, 537]
            )
        ))



    // MARK: - Е. ХАРАКТЕР

    /// Е. ХАРАКТЕР
    static let group_personality = AnalysisScale.dummy(
        identifier: .group_personality,
        title: NSLocalizedString("Е. ХАРАКТЕР", comment: "Название группы шкал")
    )


    // MARK: Норма

    /// Норма
    static let norm = AnalysisScale(
        identifier: .norm,
        title: NSLocalizedString("Норма", comment: "Название шкалы"),
        index: .common(113),
        score: .brackets(
            (33, 37, 50, 57),
            basedOn: .rawPercentage(
                positive: [39, 52, 89, 93, 98, 115, 138, 145, 146, 147, 166, 171, 213, 234, 244, 256, 258, 278, 321, 334, 336, 337, 344, 351, 368, 370, 372, 373, 375, 377, 378, 381, 382, 383, 384, 385, 386, 388, 389, 390, 392, 393, 394, 395, 396, 398, 400, 402, 404, 549],
                negative: [23, 55, 131, 167, 170, 173, 188, 194, 209, 235, 237, 262, 264, 270, 353, 367, 369, 371, 376, 379, 380, 387, 391, 399, 401, 403, 405]
            )
        ))


    // MARK: Твердость (доминирование)

    /// Твердость (доминирование)
    static let dominance = AnalysisScale(
        identifier: .dominance,
        title: NSLocalizedString("Твердость (доминирование)", comment: "Название шкалы"),
        index: .common(114),
        score: .median(
            .specific(male: 16.25, female: 15.22),
            dispersion: .specific(male: 2.94, female: 3.04),
            basedOn: .raw(
                positive: [64, 229, 255, 270, 368, 432, 523],
                negative: [32, 61, 82, 86, 94, 186, 223, 224, 240, 249, 250, 267, 268, 304, 343, 356, 395, 419, 486, 558, 562]
            )
        ))


    // MARK: Воля

    /// Воля
    static let will = AnalysisScale(
        identifier: .will,
        title: NSLocalizedString("Воля", comment: "Название шкалы"),
        index: .common(115),
        score: .brackets(
            .specific(
                male: (45, 55, 80, 90),
                female: (40, 50, 75, 85)
            ),
            basedOn: .rawPercentage(
                positive: [8, 196, 322],
                negative: [32, 40, 41, 76, 104, 202, 259, 301, 335, 339, 356]
            )
        ))


    // MARK: Педантизм

    /// Педантизм
    static let pedantry = AnalysisScale(
        identifier: .pedantry,
        title: NSLocalizedString("Педантизм", comment: "Название шкалы"),
        index: .common(116),
        score: .brackets(
            .specific(
                male: (38, 42, 60, 63),
                female: (38, 42, 60, 63)
            ),
            basedOn: .rawPercentage(
                positive: [4, 37, 83, 113, 133, 141, 149, 169, 171, 173, 198, 206, 226, 232, 249, 262, 264, 302, 361, 373, 417, 428, 432, 490, 493, 556, 557],
                negative: [6, 39, 40, 49, 56, 60, 61, 86, 94, 99, 102, 135, 142, 145, 204, 222, 228, 240, 255, 276, 277, 419, 437, 456, 487, 511, 560]
            )
        ))


    // MARK: Мнительность (предубежденность)

    /// Мнительность (предубежденность)
    static let prejudice = AnalysisScale(
        identifier: .prejudice,
        title: NSLocalizedString("Мнительность (предубежденность)", comment: "Название шкалы"),
        index: .common(117),
        score: .median(
            .specific(male: 10.46, female: 11.4),
            dispersion: .specific(male: 4.39, female: 4.27),
            basedOn: .raw(
                positive: [47, 84, 93, 106, 117, 124, 136, 139, 157, 171, 186, 250, 280, 304, 307, 313, 319, 323, 338, 349, 373, 395, 406, 411, 435, 437, 469, 485, 543],
                negative: [78, 176, 221]
            )
        ))


    // MARK: Самоконтроль

    /// Самоконтроль
    static let self_control = AnalysisScale(
        identifier: .self_control,
        title: NSLocalizedString("Самоконтроль", comment: "Название шкалы"),
        index: .common(118),
        score: .median(
            .specific(male: 24.95, female: 26.19),
            dispersion: .specific(male: 3.89, female: 3.89),
            basedOn: .raw(
                positive: [6, 20, 30, 56, 67, 105, 116, 134, 145, 162, 169, 181, 225, 236, 238, 285, 296, 319, 337, 382, 411, 418, 436, 446, 447, 460, 529, 555],
                negative: [58, 80, 92, 96, 111, 167, 174, 220, 242, 249, 250, 291, 313, 360, 378, 439, 444, 483, 488, 489, 527, 548]
            )
        ))


    // MARK: Застенчивость

    /// Застенчивость
    static let shyness = AnalysisScale(
        identifier: .shyness,
        title: NSLocalizedString("Застенчивость", comment: "Название шкалы"),
        index: .common(119),
        score: .median(
            .specific(male: 2.02, female: 2.04),
            dispersion: .specific(male: 1.58, female: 1.66),
            basedOn: .raw(
                positive: [172, 180, 201, 267, 292],
                negative: []
            )
        ))


    // MARK: Уверенность (сила Эго)

    /// Уверенность (сила Эго)
    static let confidence = AnalysisScale(
        identifier: .confidence,
        title: NSLocalizedString("Уверенность (сила Эго)", comment: "Название шкалы"),
        index: .common(120),
        score: .median(
            .specific(male: 47.7, female: 41.8),
            dispersion: .specific(male: 5.6, female: 6.2),
            basedOn: .raw(
                positive: [2, 36, 51, 95, 109, 153, 174, 181, 187, 192, 208, 221, 231, 234, 253, 270, 355, 367, 380, 410, 421, 430, 458, 513, 515],
                negative: [14, 22, 32, 33, 34, 43, 48, 58, 62, 82, 94, 100, 132, 140, 189, 209, 217, 236, 241, 244, 251, 261, 341, 344, 349, 359, 378, 384, 389, 420, 483, 488, 489, 494, 510, 525, 541, 544, 548, 554, 559, 561, 555]
            )
        ))


    // MARK: Самообладание

    /// Самообладание
    static let composure = AnalysisScale(
        identifier: .composure,
        title: NSLocalizedString("Самообладание", comment: "Название шкалы"),
        index: .common(121),
        score: .brackets(
            .specific(
                male: (65, 75, 100, 100),
                female: (55, 65, 100, 100)
            ),
            basedOn: .rawPercentage(
                positive: [],
                negative: [22, 97, 156, 194, 238, 266, 291, 303, 352, 354, 360]
            )
        ))


    // MARK: Живость (играние роли)

    /// Живость (играние роли)
    static let aliveness = AnalysisScale(
        identifier: .aliveness,
        title: NSLocalizedString("Живость (играние роли)", comment: "Название шкалы"),
        index: .common(122),
        score: .median(
            .specific(male: 18.97, female: 17.78),
            dispersion: .specific(male: 3.2, female: 3.48),
            basedOn: .raw(
                positive: [54, 81, 91, 96, 122, 137, 207, 215, 229, 282, 372, 376, 477],
                negative: [148, 183, 201, 222, 244, 250, 292, 307, 317, 348, 377, 382, 386, 447, 491, 495, 531, 564]
            )
        ))


    // MARK: Наивность

    /// Наивность
    static let naivety = AnalysisScale(
        identifier: .naivety,
        title: NSLocalizedString("Наивность", comment: "Название шкалы"),
        index: .common(123),
        score: .median(
            .specific(male: 5.02, female: 4.7),
            dispersion: .specific(male: 2.33, female: 2.12),
            basedOn: .raw(
                positive: [],
                negative: [15, 93, 109, 117, 124, 313, 316, 319, 348]
            )
        ))


    // MARK: Аморальность

    /// Аморальность
    static let immorality = AnalysisScale(
        identifier: .immorality,
        title: NSLocalizedString("Аморальность", comment: "Название шкалы"),
        index: .common(124),
        score: .median(
            .specific(male: 2.54, female: 2.72),
            dispersion: .specific(male: 1.39, female: 1.36),
            basedOn: .raw(
                positive: [143, 250, 271, 277, 298],
                negative: [289]
            )
        ))


    // MARK: Честность

    /// Честность
    static let honesty = AnalysisScale(
        identifier: .honesty,
        title: NSLocalizedString("Честность", comment: "Название шкалы"),
        index: .common(125),
        score: .brackets(
            (50, 55, 70, 80),
            basedOn: .rawPercentage(
                positive: [78, 122, 295],
                negative: [33, 157, 248, 250, 260, 287, 313, 395, 437, 448, 469, 492, 498]
            )
        ))



    // MARK: - Ж. ОТНОШЕНИЕ К ЖИЗНИ

    /// Ж. ОТНОШЕНИЕ К ЖИЗНИ
    static let group_attitude_to_life = AnalysisScale.dummy(
        identifier: .group_attitude_to_life,
        title: NSLocalizedString("Ж. ОТНОШЕНИЕ К ЖИЗНИ", comment: "Название группы шкал")
    )


    // MARK: Эскапизм

    /// Эскапизм
    static let escapism = AnalysisScale(
        identifier: .escapism,
        title: NSLocalizedString("Эскапизм", comment: "Название шкалы"),
        index: .common(126),
        score: .median(
            .specific(male: 12.82, female: 14.58),
            dispersion: .specific(male: 4.11, female: 4.18),
            basedOn: .raw(
                positive: [38, 42, 45, 47, 76, 125, 135, 150, 157, 159, 168, 179, 195, 208, 224, 225, 235, 236, 239, 246, 247, 250, 252, 277, 282, 300, 398, 529, 532],
                negative: [2, 3, 95, 98, 107, 115, 178, 268, 294, 379, 380, 395]
            )
        ))


    // MARK: Оптимизм

    /// Оптимизм
    static let optimism = AnalysisScale(
        identifier: .optimism,
        title: NSLocalizedString("Оптимизм", comment: "Название шкалы"),
        index: .common(127),
        score: .brackets(
            (47, 54, 70, 75),
            basedOn: .rawPercentage(
                positive: [20, 36, 46, 51, 54, 83, 88, 98, 107, 115, 136, 153, 160, 167, 214, 248, 249, 255, 257, 258, 264, 270, 287, 296, 306, 310, 347, 376, 379, 403, 431, 478, 484, 498, 500],
                negative: [15, 16, 35, 58, 67, 76, 84, 86, 89, 93, 94, 102, 105, 106, 110, 121, 123, 124, 129, 138, 142, 151, 162, 168, 182, 197, 202, 209, 210, 236, 239, 265, 301, 315, 331, 333, 339, 348, 357, 360, 364, 375, 383, 387, 395, 396, 397, 398, 413, 414, 418, 451, 468, 488, 492, 507, 517, 543, 555, 559]
            )
        ))


    // MARK: Терпимость (толерантность к стрессу)

    /// Терпимость (толерантность к стрессу)
    static let stress_tolerance = AnalysisScale(
        identifier: .stress_tolerance,
        title: NSLocalizedString("Терпимость (толерантность к стрессу)", comment: "Название шкалы"),
        index: .common(128),
        score: .median(
            .specific(male: 19.92, female: 18.77),
            dispersion: .specific(male: 4.48, female: 4.33),
            basedOn: .raw(
                positive: [78, 176, 221],
                negative: [33, 47, 93, 117, 124, 136, 139, 157, 171, 186, 250, 280, 304, 307, 313, 319, 338, 349, 373, 395, 406, 411, 435, 437, 469, 485, 543]
            )
        ))


    // MARK: Зависимость

    /// Зависимость
    static let dependency = AnalysisScale(
        identifier: .dependency,
        title: NSLocalizedString("Зависимость", comment: "Название шкалы"),
        index: .common(129),
        score: .median(
            .specific(male: 21.25, female: 27.1),
            dispersion: .specific(male: 7.9, female: 8),
            basedOn: .raw(
                positive: [19, 21, 24, 41, 63, 67, 70, 82, 86, 98, 100, 138, 141, 158, 165, 180, 189, 201, 212, 236, 239, 259, 267, 304, 305, 321, 337, 338, 343, 357, 361, 362, 375, 382, 383, 390, 394, 397, 398, 408, 443, 487, 488, 489, 509, 531, 549, 554, 564],
                negative: [9, 79, 107, 163, 170, 193, 264, 369]
            )
        ))


    // MARK: Приспособляемость

    /// Приспособляемость
    static let adaptivity = AnalysisScale(
        identifier: .adaptivity,
        title: NSLocalizedString("Приспособляемость", comment: "Название шкалы"),
        index: .common(130),
        score: .median(
            .specific(male: 7.29, female: 11.22),
            dispersion: .specific(male: 4.06, female: 4.75),
            basedOn: .raw(
                positive: [16, 21, 22, 23, 24, 32, 35, 41, 43, 67, 76, 127, 157, 159, 182, 189, 238, 266, 305],
                negative: [2, 3, 8, 9, 51, 103, 107, 119, 153, 178, 155, 192, 281, 289, 296]
            )
        ))


    // MARK: Цинизм

    /// Цинизм
    static let cynicism = AnalysisScale(
        identifier: .cynicism,
        title: NSLocalizedString("Цинизм", comment: "Название шкалы"),
        index: .common(131),
        score: .median(
            .specific(male: 3.3, female: 3.6),
            dispersion: .specific(male: 2.5, female: 1.96),
            basedOn: .raw(
                positive: [89, 93, 117, 124, 265, 316, 319],
                negative: []
            )
        ))


    // MARK: Плохая внутренняя приспособляемость

    /// Плохая внутренняя приспособляемость
    static let bad_internal_adaptivity = AnalysisScale(
        identifier: .bad_internal_adaptivity,
        title: NSLocalizedString("Плохая внутренняя приспособляемость", comment: "Название шкалы"),
        index: .common(132),
        score: .median(
            .specific(male: 37.81, female: 52.16),
            dispersion: .specific(male: 18.32, female: 18.06),
            basedOn: .raw(
                positive: [10, 13, 15, 16, 22, 24, 26, 27, 28, 31, 32, 33, 40, 41, 43, 48, 49, 50, 52, 53, 61, 66, 67, 69, 72, 74, 76, 84, 86, 94, 97, 102, 104, 106, 121, 123, 129, 138, 139, 142, 145, 146, 147, 151, 157, 158, 168, 171, 182, 184, 189, 197, 200, 202, 205, 209, 213, 236, 238, 241, 244, 245, 248, 252, 265, 275, 278, 284, 286, 291, 293, 297, 301, 303, 304, 305, 306, 312, 314, 315, 317, 320, 321, 324, 326, 328, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 349, 350, 351, 352, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 368, 375, 381, 384, 388, 389, 390, 393, 396, 397, 398, 400, 408, 409, 413, 414, 418, 420, 431, 442, 443, 448, 454, 467, 469, 470, 476, 494, 499, 506, 517, 526, 530, 543, 544],
                negative: [9, 20, 36, 37, 57, 107, 122, 133, 152, 257, 310, 353, 371]
            )
        ))


    // MARK: Низкая способность к достижению цели

    /// Низкая способность к достижению цели
    static let low_goal_achievement = AnalysisScale(
        identifier: .low_goal_achievement,
        title: NSLocalizedString("Низкая способность к достижению цели", comment: "Название шкалы"),
        index: .common(133),
        score: .median(
            .specific(male: 11.38, female: 11.81),
            dispersion: .specific(male: 2, female: 2.34),
            basedOn: .raw(
                positive: [97, 129, 168, 225, 249, 266, 294, 303, 369, 371, 390, 463, 515, 528],
                negative: [17, 41, 199, 232, 247, 344, 512]
            )
        ))



    // MARK: - З. ОТНОШЕНИЕ К СЕБЕ

    /// З. ОТНОШЕНИЕ К СЕБЕ
    static let group_auto_evaluation = AnalysisScale.dummy(
        identifier: .group_auto_evaluation,
        title: NSLocalizedString("З. ОТНОШЕНИЕ К СЕБЕ", comment: "Название группы шкал")
    )


    // MARK: Самооценка (самоудовлетворенность)

    /// Самооценка (самоудовлетворенность)
    static let self_esteem = AnalysisScale(
        identifier: .self_esteem,
        title: NSLocalizedString("Самооценка (самоудовлетворенность)", comment: "Название шкалы"),
        index: .common(134),
        score: .median(
            .specific(male: 21.3, female: 17.2),
            dispersion: .specific(male: 5.05, female: 5.27),
            basedOn: .raw(
                positive: [46, 54, 79, 107, 170, 242, 262, 353, 501, 521],
                negative: [32, 94, 100, 138, 141, 147, 171, 172, 201, 236, 259, 317, 321, 335, 343, 389, 394, 416, 439, 443, 499, 500, 531, 564]
            )
        ))
}



// MARK: - Utility
extension AnalysisScore {
    /// Коррекция, сырые баллы
    static let raw_k = AnalysisScore.raw(
        positive: [96],
        negative: [30, 39, 71, 89, 124, 129, 134, 138, 142, 148, 160, 170, 171, 180, 183, 217, 234, 267, 272, 296, 316, 322, 374, 383, 397, 398, 406, 461, 502]
    )


    /// Формульные единицы по шкале "Интеллектуальный показатель"
    static let raw_i99: AnalysisScore = trunc(100.0 * (.rawPercentage_i95 + .rawPercentage_i96) / .taer)


    /// Процент совпадений по шкале "Научный потенциал"
    ///
    /// Используется для подсчета интеллектуальных потенциалов (шкалы 100-102).
    static let rawPercentage_i100 = AnalysisScore.rawPercentage(
        positive: [1, 4, 8, 24, 35, 46, 59, 88, 137, 138, 146, 148, 149, 164, 167, 170, 176, 196, 200, 221, 224, 240, 241, 270, 280, 286, 295, 299, 318, 331, 349, 361, 370, 395, 403, 429, 437, 454, 456, 461, 469, 472, 478, 491, 500, 501, 503, 522, 536, 552, 560],
        negative: [32, 49, 53, 98, 100, 113, 115, 133, 141, 142, 144, 150, 159, 162, 166, 181, 188, 190, 198, 207, 210, 226, 249, 258, 262, 275, 328, 356, 357, 373, 389, 394, 415, 428, 443, 446, 449, 483, 513, 556, 557, 564]
    )


    /// Процент совпадений по шкале "Артистический потенциал"
    ///
    /// Используется для подсчета интеллектуальных потенциалов (шкалы 100-102).
    static let rawPercentage_i101 = AnalysisScore.rawPercentage(
        positive: [25, 33, 42, 58, 61, 66, 73, 77, 78, 99, 101, 102, 118, 126, 132, 138, 203, 207, 208, 222, 228, 238, 241, 244, 248, 254, 255, 256, 261, 262, 268, 270, 272, 277, 278, 284, 295, 299, 317, 323, 333, 349, 362, 372, 391, 395, 418, 420, 421, 433, 440, 442, 445, 446, 451, 452, 459, 461, 472, 478, 491, 500, 505, 506, 511, 529, 538, 547, 554],
        negative: [1, 4, 37, 133, 136, 141, 144, 171, 198, 206, 210, 219, 232, 240, 242, 300, 302, 306, 322, 324, 343, 357, 373, 378, 427, 428, 432, 443, 464, 493, 513, 550, 557, 564]
    )


    /// Процент совпадений по шкале "Религиозный потенциал"
    ///
    /// Используется для подсчета интеллектуальных потенциалов (шкалы 100-102).
    static let rawPercentage_i102 = AnalysisScore.rawPercentage(
        positive: [11, 53, 83, 88, 98, 107, 112, 115, 117, 206, 232, 249, 257, 258, 264, 295, 297, 373, 380, 390, 404, 420, 428, 432, 447, 457, 476, 483, 488, 490, 495, 504, 513, 520, 532],
        negative: [6, 15, 16, 67, 71, 81, 84, 86, 89, 93, 124, 202, 210, 236, 239, 250, 252, 253, 265, 277, 280, 315, 316, 319, 357, 369, 372, 383, 387, 395, 396, 397, 398, 418, 436, 444, 456, 464, 491, 500, 503, 526, 549]
    )


    /// Сумма Тэра, использующаяся для расчета баллоп по шкалам группы "Интнллект"
    static let taer: AnalysisScore = .rawPercentage_i95 + .rawPercentage_i96 + .rawPercentage_i97 + .rawPercentage_i98


    /// Процент совпадений по шкале "Творческий склад"
    ///
    /// Используется для подсчета суммы Тэра.
    static let rawPercentage_i95 = AnalysisScore.rawPercentage(
        positive: [15, 24, 46, 60, 73, 82, 104, 107, 118, 138, 170, 180, 212, 221, 240, 241, 244, 256, 260, 267, 270, 277, 278, 286, 292, 295, 312, 314, 321, 333, 340, 342, 349, 372, 377, 431, 433, 437, 453, 454, 455, 456, 461, 465, 472, 478, 487, 491, 500, 501, 505, 511, 531, 546, 549, 552, 560],
        negative: [57, 83, 92, 95, 99, 136, 141, 144, 152, 169, 178, 181, 198, 207, 219, 229, 259, 262, 300, 309, 322, 337, 371, 391, 393, 394, 415, 428, 446, 479, 482, 513, 547, 556, 557]
    )


    /// Процент совпадений по шкале "Эрудиционный склад"
    ///
    /// Используется для подсчета суммы Тэра.
    static let rawPercentage_i96 = AnalysisScore.rawPercentage(
        positive: [1, 4, 57, 59, 83, 95, 96, 164, 173, 178, 198, 200, 221, 233, 299, 307, 309, 331, 353, 371, 373, 380, 390, 393, 400, 404, 406, 411, 415, 428, 429, 432, 438, 440, 446, 447, 449, 467, 479, 482, 490, 493, 495, 503, 513, 521, 546, 552, 557],
        negative: [60, 82, 170, 180, 241, 256, 260, 267, 277, 321, 342, 372, 377, 437, 444, 455, 456, 491, 500, 511]
    )


    /// Процент совпадений по шкале "Рутинность"
    ///
    /// Используется для подсчета суммы Тэра.
    static let rawPercentage_i97 = AnalysisScore.rawPercentage(
        positive: [4, 6, 12, 42, 81, 83, 92, 95, 116, 126, 132, 133, 140, 141, 144, 149, 152, 181, 198, 206, 207, 210, 232, 247, 302, 394, 432, 446, 454, 497, 513, 547, 557],
        negative: [1, 8, 60, 61, 78, 101, 111, 146, 196, 204, 219, 221, 295, 318, 349, 372, 429, 465, 472, 501, 511, 537, 552]
    )


    /// Процент совпадений по шкале "Интеллектуальная активность"
    ///
    /// Используется для подсчета суммы Тэра.
    static let rawPercentage_i98 = AnalysisScore.rawPercentage(
        positive: [1, 2, 3, 8, 9, 36, 51, 56, 57, 62, 71, 95, 99, 107, 112, 115, 118, 146, 153, 163, 196, 204, 221, 219, 228, 229, 257, 264, 287, 318, 403, 461, 493, 501],
        negative: [13, 16, 20, 32, 35, 37, 40, 41, 67, 76, 84, 86, 90, 100, 102, 105, 106, 116, 132, 133, 134, 142, 147, 159, 186, 189, 202, 210, 236, 247, 267, 268, 272, 290, 301, 305, 315, 328, 331, 335, 339, 343, 356, 357, 366, 368, 389, 394, 396, 397, 398, 400, 402, 406, 414, 415, 418, 443, 451, 469, 487, 507, 509, 511, 517, 526, 531, 544, 564]
    )
}
