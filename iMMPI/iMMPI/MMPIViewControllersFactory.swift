import UIKit

struct MMPIViewControllersFactory: ViewControllersFactory {
    enum Error: Swift.Error {
        case failedInstantiatingViewController
    }


    let storyboard: UIStoryboard


    func makeRecordsListViewController() -> RecordsListViewController {
        return RecordsListViewController(style: .plain)
    }


    func makeAnalysisViewController() -> AnalysisViewController {
        return AnalysisViewController(style: .plain)
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


    func makeAnalysisOptionsViewController() throws -> AnalysisOptionsViewController {
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: ViewController.analysisOptions
            ) as? AnalysisOptionsViewController else {
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
