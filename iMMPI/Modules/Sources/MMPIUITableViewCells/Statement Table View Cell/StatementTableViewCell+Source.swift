import UIKit
import DataModel
import Localization
import UIReusableViews

extension StatementTableViewCell {
    public typealias Source = TableViewCellSource<Data>
    public typealias Data = (statement: Statement, answer: AnswerType)

    public static func makeSourceForInput() -> Source {
        return .nib(
            name: "StatementTableViewCell+Input",
            bundle: .module,
            identifier: "StatementTableViewCell",
            update: update
        )
    }

    public static func makeSourceForReview() -> Source {
        return .nib(
            name: "StatementTableViewCell+Review",
            bundle: .module,
            identifier: "StatementTableViewCell",
            update: update
        )
    }
}

private func update(
    _ cell: StatementTableViewCell,
    with data: StatementTableViewCell.Data?
) {
    guard let data = data else {
        return
    }

    cell.identifierLabel?.text = "\(data.statement.identifier)"
    cell.statementTextLabel?.text = data.statement.text

    switch data.answer {
    case .positive:
        cell.answerLabel?.text = Strings.Analysis.yes
        cell.segmentedControl?.selectedSegmentIndex = 1

    case .negative:
        cell.answerLabel?.text = Strings.Analysis.no
        cell.segmentedControl?.selectedSegmentIndex = 0

    case .unknown:
        cell.answerLabel?.text = ""
        cell.segmentedControl?.selectedSegmentIndex = UISegmentedControl.noSegment
    }
}
