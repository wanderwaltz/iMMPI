import Foundation

final class AnalysisMenuActionContext {
    let router: Router?

    let record: TestRecordProtocol
    let analyser: Analyzer


    private(set) lazy var questionnaire: Questionnaire? = {
        try? Questionnaire(gender: self.record.person.gender, ageGroup: self.record.person.ageGroup)
    }()


    private(set) lazy var htmlReportGenerators: [HtmlReportGenerator] = {
        let answers = self.questionnaire.flatMap({ HtmlReportGenerator.answers(questionnaire: $0) })
        let reliability = self.questionnaire.flatMap({ questionnaire in
            self.analyser.group(withName: Strings.Analysis.reliabilityGroupName).flatMap({ group in
                HtmlReportGenerator.details(for: group, questionnaire: questionnaire)
            })
        })

        return [
            .overall,
            answers,
            reliability
        ]
        .flatMap({ $0 })
    }()


    init(router: Router?, record: TestRecordProtocol, analyser: Analyzer) {
        self.router = router
        self.record = record
        self.analyser = analyser
    }


    deinit {
        print(">>>")
    }
}
