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


    func makeEditRecordViewController() throws -> EditTestRecordViewController {
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: ViewController.editRecord
            ) as? EditTestRecordViewController else {
                throw Error.failedInstantiatingViewController
        }

        return controller
    }


    func makeAnswersInputViewController() throws -> TestAnswersInputViewController {
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: ViewController.answersInput
            ) as? TestAnswersInputViewController else {
                throw Error.failedInstantiatingViewController
        }

        return controller
    }
}


fileprivate enum ViewController {
    static let testRecords = "com.immpi.viewControllers.testRecords"
    static let editRecord = "com.immpi.viewControllers.editRecord"
    static let answersInput = "com.immpi.viewControllers.answersInput"
    static let analysisOptions = "com.immpi.viewControllers.analysisOptions"
}
