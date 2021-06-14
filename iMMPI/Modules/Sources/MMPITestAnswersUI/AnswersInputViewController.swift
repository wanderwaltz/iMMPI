import UIKit
import DataModel
import Localization
import MMPIUITableViewCells

/// This class presents interface suitable to entering answers for the MMPI test 
/// in order starting with first and finishing with last question.
///
/// This view controller has a set of toolbar items which provide the means to enter 
/// positive/negative answers to each statement. A current statement is displayed as usual, 
/// all other (not currently selected) statements are dimmed so the attention of the user
/// is focused on a single selected statement.
public final class AnswersInputViewController: AnswersViewController {
    @objc @IBOutlet fileprivate var answersInputView: UIView?
    fileprivate var statementIndex: Int = 0
}


extension AnswersInputViewController {
    fileprivate func setStatementIndex(_ index: Int) {
        guard let viewModel = viewModel else {
            return
        }

        if 0 <= index && index < viewModel.statementsCount {
            statementIndex = index
            tableView?.reloadData()
            tableView?.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: false)
            title = String(format: Strings.Analysis.format_N_of_M, statementIndex+1, viewModel.statementsCount)
        }
    }


    @discardableResult
    fileprivate func setPreviousStatementIndex() -> Bool {
        if statementIndex > 0 {
            setStatementIndex(statementIndex - 1)
            return true
        }
        else {
            return false
        }
    }


    @discardableResult
    fileprivate func setNextStatementIndex() -> Bool {
        guard let viewModel = viewModel else {
            return false
        }

        if let statement = viewModel.statement(at: statementIndex) {
            if statementIndex < viewModel.statementsCount - 1
                && answers.answer(for: statement.identifier) != .unknown {
                setStatementIndex(statementIndex + 1)
                return true
            }
        }

        return false
    }


    fileprivate func recordAnswer(_ answer: AnswerType) {
        guard let viewModel = viewModel else {
            return
        }

        if let statement = viewModel.statement(at: statementIndex) {
            setAnswer(answer, for: statement)
        }

        if false == setNextStatementIndex() {
            router?.displayAnalysis(for: [viewModel.record], sender: self)
        }
    }
}


extension AnswersInputViewController {
    @objc @IBAction fileprivate func prevButtonAction(_ sender: Any?) {
        setPreviousStatementIndex()
    }


    @objc @IBAction fileprivate func nextButtonAction(_ sender: Any?) {
        setNextStatementIndex()
    }


    @objc @IBAction fileprivate func negativeAnswerButtonAction(_ sender: Any?) {
        recordAnswer(.negative)
    }


    @objc @IBAction fileprivate func positiveAnswerButtonAction(_ sender: Any?) {
        recordAnswer(.positive)
    }
}


extension AnswersInputViewController {
    public override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = super.tableView(
            tableView,
            cellForRowAt: indexPath
        ) as! StatementTableViewCell

        cell.isCurrent = statementIndex == indexPath.row
        return cell
    }
}
