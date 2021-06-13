import UIKit
import DataModel
import Localization

extension StatementTableViewCell {
    typealias Source = TableViewCellSource<Data>
    typealias Data = (statement: Statement, answer: AnswerType)


    static func makeSourceForInput() -> Source {
        return .nib(UINib(nibName: "StatementTableViewCell+Input", bundle: .main),
            identifier: "StatementTableViewCell",
            update: update
        )
    }


    static func makeSourceForReview() -> Source {
        return .nib(UINib(nibName: "StatementTableViewCell+Review", bundle: .main),
        identifier: "StatementTableViewCell",
        update: update
        )
    }
}


fileprivate func update(_ cell: StatementTableViewCell, with data: StatementTableViewCell.Data?) {
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
