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
            .group_reliability, // А. НАДЕЖНОСТЬ
            .sr                 // 1. Общественная диссимуляция
            ])
    }
}
