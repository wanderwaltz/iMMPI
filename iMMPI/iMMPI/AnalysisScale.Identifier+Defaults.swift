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

    /// Органическое поражение хвостатого ядра
    static let nucleus_injury = AnalysisScale.Identifier("nucleus_injury")



    // MARK: - В. ПСИХИКА

    /// В. ПСИХИКА
    static let group_psyche = AnalysisScale.Identifier("В. ПСИХИКА", nesting: 0)

    /// Ложь (неискренность)
    static let l = AnalysisScale.Identifier("L")

    /// Достоверность (невалидность)
    static let f = AnalysisScale.Identifier("F")

    /// Коррекция
    static let k = AnalysisScale.Identifier("K")

    /// Ипохондрия (Сверхконтроль)
    static let hs = AnalysisScale.Identifier("Hs")

    /// Сверхконтроль Я (зажатость)
    static let hs_self = AnalysisScale.Identifier("Hs_self", nesting: 2)

    /// Предипохондрическое состояние
    static let hs_pre = AnalysisScale.Identifier("Hs_pre", nesting: 2)

    /// Сосредоточенность на здоровье
    static let hs_health = AnalysisScale.Identifier("Hs_health", nesting: 2)

    /// Чистая ипохондрия
    static let hs_pure = AnalysisScale.Identifier("Hs_pure", nesting: 2)

    /// Невротический сверхконтроль
    static let hs_neurotic = AnalysisScale.Identifier("Hs_neurotic", nesting: 2)

    /// Невротическое ослабление сверхконтроля
    static let hs_neurotic_weak = AnalysisScale.Identifier("Hs_neurotic_weak", nesting: 2)

    /// Депрессия (Пессимистичность)
    static let d = AnalysisScale.Identifier("D")

    /// Чистая депрессия
    static let d_pure = AnalysisScale.Identifier("D_pure", nesting: 2)

    /// Субъективная депрессия
    static let d_subjective = AnalysisScale.Identifier("D_subjective", nesting: 2)

    /// Психомоторная заторможенность
    static let d_block = AnalysisScale.Identifier("D_block", nesting: 2)

    /// Мрачность
    static let d_gloom = AnalysisScale.Identifier("D_gloom", nesting: 2)

    /// Явная депрессия
    static let d_evident = AnalysisScale.Identifier("D_evident", nesting: 2)

    /// Депрессивная реакция
    static let d_reaction = AnalysisScale.Identifier("D_reaction", nesting: 2)

    /// Мягкая депрессия
    static let d_mild = AnalysisScale.Identifier("D_mild", nesting: 2)

    /// Истерия
    static let hy = AnalysisScale.Identifier("Hy")

    /// Эмоциональная незрелость
    static let hy_immaturity = AnalysisScale.Identifier("Hy_immaturity", nesting: 2)

    /// Чистая истерия
    static let hy_pure = AnalysisScale.Identifier("Hy_pure", nesting: 2)

    /// Явная истерия
    static let hy_evident = AnalysisScale.Identifier("Hy_evident", nesting: 2)

    /// Скрытая истерия
    static let hy_hidden = AnalysisScale.Identifier("Hy_hidden", nesting: 2)

    /// Эмоциональная чувствительность
    static let hy_sensitivity = AnalysisScale.Identifier("Hy_sensitivity", nesting: 2)

    /// Психопатия (Импульсивность)
    static let pd = AnalysisScale.Identifier("Pd")

    /// Импульсивность
    static let pd_impulsiveness = AnalysisScale.Identifier("Pd_impulsiveness", nesting: 2)

    /// Чистая психопатия
    static let pd_pure = AnalysisScale.Identifier("Pd_pure", nesting: 2)

    /// Явные психопатические отклонения
    static let pd_evident = AnalysisScale.Identifier("Pd_evident", nesting: 2)

    /// Скрытые психопатические отклонения
    static let pd_hidden = AnalysisScale.Identifier("Pd_hidden", nesting: 2)

    /// Выраженная враждебность
    static let pd_hostility = AnalysisScale.Identifier("Pd_hostility", nesting: 2)

    /// Психомоторная акселерация
    static let pd_accel = AnalysisScale.Identifier("Pd_accel", nesting: 2)

    /// Осознанная выраженная враждебность
    static let pd_intended_hostility = AnalysisScale.Identifier("Pd_intended_hostility", nesting: 2)

    /// Контроль над враждебностью
    static let pd_hostility_control = AnalysisScale.Identifier("Pd_hostility_control", nesting: 2)

    /// Подавление агрессии
    static let pd_aggro_suppression = AnalysisScale.Identifier("Pd_aggro_suppression", nesting: 2)

    /// Половое развитие
    static let mf = AnalysisScale.Identifier("Mf")

    /// Женственность
    static let mf_femininity = AnalysisScale.Identifier("Mf_femininity", nesting: 2)

    /// Женственность интересов
    static let mf_feminine_values = AnalysisScale.Identifier("Mf_feminine_values", nesting: 2)

    /// Ригидность
    static let mf_rigidness = AnalysisScale.Identifier("Mf_rigidness", nesting: 2)

    /// Стабильность профиля (Уравновешенность)
    static let mf_stability = AnalysisScale.Identifier("Mf_stability", nesting: 2)

    /// Паранойя (Ригидность)
    static let pa = AnalysisScale.Identifier("Pa")

    /// Чистая паранойя
    static let pa_pure = AnalysisScale.Identifier("Pa_pure", nesting: 2)

    /// Идеи преследования
    static let pa_stalking = AnalysisScale.Identifier("Pa_stalking", nesting: 2)

    /// Идеи отравления
    static let pa_poisoning = AnalysisScale.Identifier("Pa_poisoning", nesting: 2)

    /// Явная паранойя
    static let pa_evident = AnalysisScale.Identifier("Pa_evident", nesting: 2)

    /// Скрытая паранойя
    static let pa_hidden = AnalysisScale.Identifier("Pa_hidden", nesting: 2)

    /// Фактор паранойи
    static let pa_factor = AnalysisScale.Identifier("Pa_factor", nesting: 2)

    /// Комплекс осуждения (комплекс вины)
    static let pa_guilt = AnalysisScale.Identifier("Pa_guilt", nesting: 2)

    /// Психастения (Тревожность)
    static let pf = AnalysisScale.Identifier("Pf")

    /// Реакция тревоги
    static let pf_anxiety_reaction = AnalysisScale.Identifier("Pf_anxiety_reaction", nesting: 2)

    /// Тревога
    static let pf_anxiety = AnalysisScale.Identifier("Pf_anxiety", nesting: 2)

    /// Вытеснение тревоги
    static let pf_anxiety_repression = AnalysisScale.Identifier("Pf_anxiety_repression", nesting: 2)

    /// Осознанная тревога
    static let pf_realized_anxiety = AnalysisScale.Identifier("Pf_realized_anxiety", nesting: 2)

    /// Шизофрения (индивидуалистичность)
    static let sc = AnalysisScale.Identifier("Sc")

    /// Оригинальность
    static let sc_originality = AnalysisScale.Identifier("Sc_originality", nesting: 2)

    /// Прогноз шизофрении
    static let sc_prognosis = AnalysisScale.Identifier("Sc_prognosis", nesting: 2)

    /// Параноидная шизофрения
    static let sc_paranoid = AnalysisScale.Identifier("Sc_paranoid", nesting: 2)

    /// Чистая шизофрения
    static let sc_pure = AnalysisScale.Identifier("Sc_pure", nesting: 2)

    /// Причудливость сенсорного восприятия
    static let sc_sensoric = AnalysisScale.Identifier("Sc_sensoric", nesting: 2)

    /// Эмоциональное отчуждение
    static let sc_emotional = AnalysisScale.Identifier("Sc_emotional", nesting: 2)

    /// Гипомания (оптимистичность)
    static let ma = AnalysisScale.Identifier("Ma")
}
