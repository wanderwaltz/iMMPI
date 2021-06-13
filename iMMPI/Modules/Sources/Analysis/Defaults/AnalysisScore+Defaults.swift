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