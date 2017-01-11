import Foundation

extension StatementTableViewCell {
    typealias Source = TableViewCellSource<Data>
    typealias Data = (statement: Statement, answer: AnswerType, delegate: StatementTableViewCellDelegate)

    static func makePreregisteredSource() -> Source {
        return .preregistered(
            identifier: StatementTableViewCell.reuseIdentifier(),
            update: { (cell: StatementTableViewCell, data: Data?) in
                guard let data = data else {
                    return
                }

                cell.delegate = data.delegate

                cell.statementIDLabel?.text = "\(data.statement.statementID)"
                cell.statementTextLabel?.text = data.statement.text

                switch data.answer {
                case .positive:
                    cell.statementAnswerLabel?.text = Strings.yes
                    cell.statementSegmentedControl?.selectedSegmentIndex = 1

                case .negative:
                    cell.statementAnswerLabel?.text = Strings.no
                    cell.statementSegmentedControl?.selectedSegmentIndex = 0

                case .unknown:
                    cell.statementAnswerLabel?.text = ""
                    cell.statementSegmentedControl?.selectedSegmentIndex = UISegmentedControlNoSegment
                }
        })
    }
}
