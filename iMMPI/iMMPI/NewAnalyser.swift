import Foundation

// TODO: rename later
struct NewAnalyser {
    let scales: [AnalysisScale]

    init(scales: [AnalysisScale]) {
        self.scales = scales
    }
}


extension NewAnalyser {
    init() {
        self.init(scales: [
            .group_reliability,      // А. НАДЕЖНОСТЬ
                .sr,                 //     Общественная диссимуляция
                .ds_r,               //     Медицинская симуляция
                .ta,                 //     Комплекс Панурга
                .hy_s,               //     Тенденция перечить
                .defensive_reaction, //     Защитная реакция на тест
                .self_bashing,       //     Стремление наговорить на себя
            .group_health,           // Б. Здоровье
                .maturity,           //     Старость (зрелость)
                .nt,                 //     Потребность в лечении (пренебрежение здоровьем)
                .sv,                 //     Половая активность
                .sdv,                //     Половые отклонения
                .a1,                 //     Алкоголизм 1
                .ad,                 //     Алкогольная дифференциация
                .a2,                 //     Алкоголизм 2
            ])
    }
}
