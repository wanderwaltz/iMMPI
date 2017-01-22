import Foundation

extension AnalysisScale.Identifier {
    // MARK: - А. НАДЕЖНОСТЬ

    /// А. НАДЕЖНОСТЬ
    static let group_reliability = AnalysisScale.Identifier("А. НАДЕЖНОСТЬ", nesting: 0)

    /// Общественная диссимуляция, социальное присутствие
    static let sr = AnalysisScale.Identifier("Sr")

    /// Медицинская симуляция
    static let ds_r = AnalysisScale.Identifier("Ds-r")

    /// Комплекс Панурга
    static let ta = AnalysisScale.Identifier("Ta")

    /// Тенденция перечить
    static let hy_s = AnalysisScale.Identifier("Hy-s")

    /// Защитная реакция на тест
    static let defensive_reaction = AnalysisScale.Identifier("defensive_reaction")

    /// Стремление наговорить на себя
    static let self_bashing = AnalysisScale.Identifier("self_bashing")



    // MARK: - Б. ЗДОРОВЬЕ

    /// Б. ЗДОРОВЬЕ
    static let group_health = AnalysisScale.Identifier("Б. ЗДОРОВЬЕ", nesting: 0)

    /// Старость (зрелость)
    static let maturity = AnalysisScale.Identifier("maturity")

    /// Потребность в лечении (пренебрежение здоровьем)
    static let nt = AnalysisScale.Identifier("Nt")

    /// Половая активность
    static let sv = AnalysisScale.Identifier("Sv")

    /// Половые отклонения
    static let sdv = AnalysisScale.Identifier("Sdv")

    /// Алкоголизм 1
    static let a1 = AnalysisScale.Identifier("a1")

    /// Алкогольная дифференциация
    static let ad = AnalysisScale.Identifier("ad")

    /// Алкоголизм 2
    static let a2 = AnalysisScale.Identifier("a2")

    /// Предрасположенность к головным болям
    static let headaches = AnalysisScale.Identifier("headaches")

    /// Соматические жалобы
    static let soma_complaints = AnalysisScale.Identifier("soma_complaints")

    /// Реакция соматизации
    static let soma_reaction = AnalysisScale.Identifier("soma_reaction")

    /// Физические расстройства
    static let physical_disorders = AnalysisScale.Identifier("physical_disorders")

    /// Психическая заторможенность
    static let mental_block = AnalysisScale.Identifier("mental_block")

    /// Эпилепсия
    static let epilepsy = AnalysisScale.Identifier("epilepsy")
}
