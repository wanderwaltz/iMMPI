import UIKit

struct MMPIViewControllersFactory: ViewControllersFactory {
    enum Error: Swift.Error {
        case failedInstantiatingViewController
    }


    let storyboard: UIStoryboard
    let analysisSettings: AnalysisSettings = ValidatingAnalysisSettings(UserDefaultsAnalysisSettings())


    func makeRecordsListViewController() -> RecordsListViewController {
        return RecordsListViewController(style: .plain)
    }


    func makeEditRecordViewController() -> EditTestRecordViewController {
        return EditTestRecordViewController(style: .grouped)
    }


    func makeAnalysisViewController() -> AnalysisViewController {
        let controller = AnalysisViewController(style: .plain)

        controller.settings = analysisSettings
        controller.cellSource = AnalyserTableViewCell.makeSource(with: .default(with: analysisSettings))

        return controller
    }


    func makeAnalysisOptionsViewController() -> AnalysisOptionsViewController {
        let controller = AnalysisOptionsViewController(style: .plain)

        controller.viewModel = AnalysisOptionsViewModel(settings: analysisSettings)
        return controller
    }


    func makeAnswersReviewViewController() -> TestAnswersViewController {
        let controller = TestAnswersViewController()
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)

        tableView.rowHeight = 64.0

        tableView.dataSource = controller
        controller.tableView = tableView

        return controller
    }


    func makeAnswersInputViewController() -> TestAnswersInputViewController {
        return TestAnswersInputViewController(
            nibName: "TestAnswersInputViewController",
            bundle: Bundle(for: TestAnswersInputViewController.self)
        )
    }
}
