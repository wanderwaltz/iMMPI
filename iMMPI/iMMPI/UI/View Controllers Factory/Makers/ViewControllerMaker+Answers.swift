import UIKit

extension ViewControllerMaker {
    static func answersInputForRecord(with identifier: RecordIdentifier) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            guard let record = context.storage.findRecord(with: identifier) else {
                assertionFailure("Could not find record with identifier: \(identifier)")
                return UIViewController()
            }

            guard let questionnaire = try? Questionnaire(record: record) else {
                assertionFailure("Failed loading questionnaire for record with identifier: \(identifier)")
                return UIViewController()
            }

            let controller = AnswersInputViewController(
                nibName: "AnswersInputViewController",
                bundle: Bundle(for: AnswersInputViewController.self)
            )

            controller.viewModel = DefaultAnswersViewModel(record: record, questionnaire: questionnaire)
            controller.inputDelegate = context.answersInputDelegate
            controller.cellSource = StatementTableViewCell.makeSourceForInput()

            return controller
        })
    }

    static func answersReviewForRecord(with identifier: RecordIdentifier) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            guard let record = context.storage.findRecord(with: identifier) else {
                assertionFailure("Could not find record with identifier: \(identifier)")
                return UIViewController()
            }

            let controller = AnswersViewController()
            let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)

            tableView.rowHeight = 64.0

            tableView.dataSource = controller
            controller.tableView = tableView

            guard let questionnaire = try? Questionnaire(record: record) else {
                assertionFailure("Failed loading questionnaire for record with identifier: \(identifier)")
                return controller
            }

            controller.viewModel = DefaultAnswersViewModel(record: record, questionnaire: questionnaire)
            controller.inputDelegate = context.answersInputDelegate
            controller.cellSource = StatementTableViewCell.makeSourceForReview()

            return controller
        })
    }
}
