import UIKit

struct MMPIViewControllersFactory: ViewControllersFactory {
    enum Error: Swift.Error {
        case failedInstantiatingViewController
    }


    let storyboard: UIStoryboard


    func makeRecordsListViewController() -> RecordsListViewController {
        return RecordsListViewController(style: .plain)
    }


    func makeEditRecordViewController() throws -> EditTestRecordViewController {
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: ViewController.editRecord
            ) as? EditTestRecordViewController else {
                throw Error.failedInstantiatingViewController
        }

        return controller
    }


    func makeAnalysisViewController() throws -> AnalysisViewController {
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: ViewController.analysis
            ) as? AnalysisViewController else {
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
    static let analysis = "com.immpi.viewControllers.analysis"
}
