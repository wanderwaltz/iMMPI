import Foundation
import DataModel

public struct Analyser {
    public let scales: [AnalysisScale]

    init(scales: [AnalysisScale]) {
        self.scales = scales
    }
}


extension Analyser {
    public func result(for record: RecordProtocol) -> AnalysisResult {
        return AnalysisResult(record: record, scales: scales.map({ $0.bind(record) }))
    }
}


extension Analyser {
    public init() {
        self.init(scales: [
            .group_reliability,             // А. НАДЕЖНОСТЬ
                .sr,                        //     Общественная диссимуляция
                .ds_r,                      //     Медицинская симуляция
                .ta,                        //     Комплекс Панурга
                .hy_s,                      //     Тенденция перечить
                .defensive_reaction,        //     Защитная реакция на тест
                .self_bashing,              //     Стремление наговорить на себя
            .group_health,                  // Б. Здоровье
                .maturity,                  //     Старость (зрелость)
                .nt,                        //     Потребность в лечении (пренебрежение здоровьем)
                .sv,                        //     Половая активность
                .sdv,                       //     Половые отклонения
                .a1,                        //     Алкоголизм 1
                .ad,                        //     Алкогольная дифференциация
                .a2,                        //     Алкоголизм 2
                .headaches,                 //     Предрасположенность к головным болям
                .soma_complaints,           //     Соматические жалобы
                .soma_reaction,             //     Реакция соматизации
                .physical_disorders,        //     Физические расстройства
                .mental_block,              //     Психическая заторможенность
                .epilepsy,                  //     Эпилепсия
                .nucleus_injury,            //     Органическое поражение хвостатого ядра
            .group_psyche,                  // В. ПСИХИКА
                .l,                         //     Ложь (неискренность)
                .f,                         //     Достоверность (невалидность)
                .k,                         //     Коррекция
                .hs,                        //     Ипохондрия (Сверхконтроль)
                    .hs_self,               //         Сверхконтроль Я (зажатость)
                    .hs_pre,                //         Предипохондрическое состояние
                    .hs_health,             //         Сосредоточенность на здоровье
                    .hs_pure,               //         Чистая ипохондрия
                    .hs_neurotic,           //         Невротический сверхконтроль
                    .hs_neurotic_weak,      //         Невротическое ослабление сверхконтроля
                .d,                         //     Депрессия (Пессимистичность)
                    .d_pure,                //         Чистая депрессия
                    .d_subjective,          //         Субъективная депрессия
                    .d_block,               //         Психомоторная заторможенность
                    .d_gloom,               //         Мрачность
                    .d_evident,             //         Явная депрессия
                    .d_reaction,            //         Депрессивная реакция
                    .d_mild,                //         Мягкая депрессия
                .hy,                        //     Истерия
                    .hy_immaturity,         //         Эмоциональная незрелость
                    .hy_pure,               //         Чистая истерия
                    .hy_evident,            //         Явная истерия
                    .hy_hidden,             //         Скрытая истерия
                    .hy_sensitivity,        //         Эмоциональная чувствительность
                .pd,                        //     Психопатия (Импульсивность)
                    .pd_impulsiveness,      //         Импульсивность
                    .pd_pure,               //         Чистая психопатия
                    .pd_evident,            //         Явные психопатические отклонения
                    .pd_hidden,             //         Скрытые психопатические отклонения
                    .pd_hostility,          //         Выраженная враждебность
                    .pd_accel,              //         Психомоторная акселерация
                    .pd_intended_hostility, //         Осознанная выраженная враждебность
                    .pd_hostility_control,  //         Контроль над враждебностью
                    .pd_aggro_suppression,  //         Подавление агрессии
                .mf,                        //     Половое развитие
                    .mf_femininity,         //         Женственность
                    .mf_feminine_values,    //         Женственность интересов
                    .mf_rigidness,          //         Ригидность
                    .mf_stability,          //         Стабильность профиля (Уравновешенность)
                .pa,                        //     Паранойя (Ригидность)
                    .pa_pure,               //         Чистая паранойя
                    .pa_stalking,           //         Идеи преследования
                    .pa_poisoning,          //         Идеи отравления
                    .pa_evident,            //         Явная паранойя
                    .pa_hidden,             //         Скрытая паранойя
                    .pa_factor,             //         Фактор паранойи
                    .pa_guilt,              //         Комплекс осуждения (комплекс вины)
                .pf,                        //     Психастения (Тревожность)
                    .pf_anxiety_reaction,   //         Реакция тревоги
                    .pf_anxiety,            //         Тревога
                    .pf_anxiety_repression, //         Вытеснение тревоги
                    .pf_realized_anxiety,   //         Осознанная тревога
                .sc,                        //     Шизофрения (индивидуалистичность)
                    .sc_originality,        //         Оригинальность
                    .sc_prognosis,          //         Прогноз шизофрении
                    .sc_paranoid,           //         Параноидная шизофрения
                    .sc_pure,               //         Чистая шизофрения
                    .sc_sensoric,           //         Причудливость сенсорного восприятия
                    .sc_emotional,          //         Эмоциональное отчуждение
                .ma,                        //     Гипомания (оптимистичность)
                    .ma_pure,               //         Чистая гипомания
                    .ma_evident,            //         Явная гипомания
                    .ma_hidden,             //         Скрытая гипомания
                .si,                        //     Интраверсия
                .fa1,                       //     1-й фактор А
                .fr2,                       //     2-й фактор R
                .ne,                        //     Невротизм
                .pne,                       //     Психоневроз
                .ie,                        //     Оценка улучшения
                .cp,                        //     Предсказание изменений
                .re,                        //     Рецидивизм
            .group_intelligence,            // Г. ИНТЕЛЛЕКТ
                .i95,                       //     Творческий склад
                .i96,                       //     Эрудиционный склад
                .i97,                       //     Рутинность
                .i98,                       //     Интеллектуальная активность
                .i99,                       //     Интеллектуальный показатель
                .i100,                      //     Научный потенциал
                .i101,                      //     Артистический потенциал
                .i102,                      //     Религиозный потенциал
                .i103,                      //     Интеллектуальная продуктивность
                .i104,                      //     Творческая продуктивность
                .i105,                      //     Интеллектуальная эффективность
                .i106,                      //     Интеллектуальный коэффициент
                .i107,                      //     Психологические интересы
            .group_work,                    // Д. ТРУДОВЫЕ КАЧЕСТВА
                .educability,               //    Способность к обучению
                .working_capacity,          //    Работоспособность (отношение к работе)
                .student_potential,         //    Школьный потенциал
                .teacher_potential,         //    Преподавательский потенциал
                .lawyer_personality,        //    Адвокатский тип личности
            .group_personality,             // Е. ХАРАКТЕР
                .norm,                      //    Норма
                .dominance,                 //    Твердость (доминирование)
                .will,                      //    Воля
                .pedantry,                  //    Педантизм
                .prejudice,                 //    Мнительность (предубежденность)
                .self_control,              //    Самоконтроль
                .shyness,                   //    Застенчивость
                .confidence,                //    Уверенность (сила Эго)
                .composure,                 //    Самообладание
                .aliveness,                 //    Живость (играние роли)
                .naivety,                   //    Наивность
                .immorality,                //    Аморальность
                .honesty,                   //    Честность
            .group_attitude_to_life,        // Ж. ОТНОШЕНИЕ К ЖИЗНИ
                .escapism,                  //    Эскапизм
                .optimism,                  //    Оптимизм
                .stress_tolerance,          //    Терпимость (толерантность к стрессу)
                .dependency,                //    Зависимость
                .adaptivity,                //    Приспособляемость
                .cynicism,                  //    Цинизм
                .bad_internal_adaptivity,   //    Плохая внутренняя приспособляемость
                .low_goal_achievement,      //    Низкая способность к достижению цели
            .group_auto_evaluation,         // З. ОТНОШЕНИЕ К СЕБЕ
                .self_esteem,               //    Самооценка (самоудовлетворенность)
                .abjection,                 //    Приниженность
                .self_alienation,           //    Самоотчужденность
                .bigotry,                   //    Ханжество
                .auto_evaluation,           //    Отношение к себе
            .group_others_evaluation,       // И. ОТНОШЕНИЕ К ЛЮДЯМ
                .favour,                    //    Благосклонность
                .hostility,                 //    Враждебность
                .altruism,                  //    Альтруизм
                .need_for_affection,        //    Нужда в привязанности
                .rivalry,                   //    Соперничество
                .vitriol,                   //    Язвительность
                .authority_problem,         //    Проблема авторитарности
                .self_righteousness,        //    Фарисейство
            .group_social_status,           // К. ПОЛОЖЕНИЕ СРЕДИ ЛЮДЕЙ
                .conscience,                //    Преступность (совестливость)
                .communicativeness,         //    Коммуникативность (социальное участие)
                .collectivism,              //    Коллективизм (студенческий староста)
                .conformism,                //    Конформизм (конверсионная реакция)
                .authority,                 //    Авторитет
                .female_success,            //    Успех женский
                .leadership,                //    Лидерство
                .social_status,             //    Социальный статус
                .social_alienation,         //    Социальное отчуждение
                .social_value,              //    Социальная значимость человека
                .social_certainty,          //    Социальная уверенность человека
                .social_responsibility,     //    Социальная ответственность
                .social_needs,              //    Социальные потребности
                .consumer_tendency,         //    Потребительская тенденция
                .responsibility_traits,     //    Черты ответственности
                .crime_1,                   //    Преступность 1
                .domination,                //    Доминирование
                .family_disharmony,         //    Семейная дисгармония
                .hypnability,               //    Гипнабельность
            ])
    }
}
