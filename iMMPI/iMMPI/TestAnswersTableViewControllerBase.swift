import UIKit

/// A base class for presenting and editing TestRecordProtocol record answers in a UITableView-driven UI.
///
/// This class uses StatementTableViewCell cells to display the statements of the questionnaire. 
/// The UITableViewDataSource methods are implemented to display the questionnaire contents in a single section list.
///
/// `TestAnswersTableViewControllerBase` is automatically set as the delegate for each of the `StatementTableViewCell`
/// used in the table view.
///
/// It is expected that the table view does return a `StatementTableViewCell` object for 
/// `StatementTableViewCell.reuseIdentifier()` string (this is set up in the storyboard).
///
/// **See also:** `TestAnswersInputViewController`, `TestAnswersViewController`.
class TestAnswersTableViewControllerBase: UIViewController, UsingRouting {
    weak var inputDelegate: TestAnswersInputDelegate?

    @IBOutlet var tableView: UITableView?

    var viewModel: TestAnswersViewModel? {
        willSet {
            viewModel?.onDidUpdate = Constant.void()
        }

        didSet {
            if let viewModel = viewModel {
                answers = viewModel.record.testAnswers.makeCopy()
                viewModel.onDidUpdate = { [weak self] in
                    self?.tableView?.reloadData()
                }
            }
        }
    }

    fileprivate(set) var answers = TestAnswers()
}


extension TestAnswersTableViewControllerBase {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.setNeedsUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveRecord()
    }
}


extension TestAnswersTableViewControllerBase {
    func setAnswer(_ answer: AnswerType, for statement: Statement) {
        guard let record = viewModel?.record else {
            return
        }

        answers.setAnswer(answer, for: statement.statementID)
        inputDelegate?.testAnswersViewController(self, didSet: answer, for: statement, record: record)
    }
}


extension TestAnswersTableViewControllerBase {
    fileprivate func saveRecord() {
        guard let record = viewModel?.record else {
            return
        }

        inputDelegate?.testAnswersInputViewController(self, didSet: answers, for: record)
    }
}


// MARK: - UITableViewDataSource
extension TestAnswersTableViewControllerBase: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.statementsCount ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatementTableViewCell.reuseIdentifier())
            as! StatementTableViewCell

        cell.delegate = self

        if let statement = viewModel?.statement(at: indexPath.row) {
            cell.statementIDLabel?.text = "\(statement.statementID)"
            cell.statementTextLabel?.text = statement.text

            switch answers.answer(for: statement.statementID) {
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
        }

        return cell
    }
}


extension TestAnswersTableViewControllerBase: StatementTableViewCellDelegate {
    func statementTableViewCell(_ cell: StatementTableViewCell, segmentedControlChanged selectedSegmentIndex: Int) {
        if let indexPath = tableView?.indexPath(for: cell), let statement = viewModel?.statement(at: indexPath.row) {
            switch selectedSegmentIndex {
            case 0: setAnswer(.negative, for: statement)
            case 1: setAnswer(.positive, for: statement)
            default: setAnswer(.unknown, for: statement)
            }
        }
    }
}
