import UIKit

/// A base class for presenting and editing RecordProtocol record answers in a UITableView-driven UI.
///
/// This class uses StatementTableViewCell cells to display the statements of the questionnaire. 
/// The UITableViewDataSource methods are implemented to display the questionnaire contents in a single section list.
///
/// `AnswersTableViewControllerBase` is automatically set as the delegate for each of the `StatementTableViewCell`
/// used in the table view.
///
/// It is expected that the table view does return a `StatementTableViewCell` object for 
/// `StatementTableViewCell.reuseIdentifier()` string (this is set up in the storyboard).
///
/// **See also:** `AnswersInputViewController`, `AnswersViewController`.
class AnswersViewController: UIViewController, UsingRouting {
    weak var inputDelegate: AnswersInputDelegate?

    var cellSource = StatementTableViewCell.makeSourceForReview()

    @IBOutlet var tableView: UITableView?

    var viewModel: AnswersViewModel? {
        didSet {
            if let viewModel = viewModel {
                answers = viewModel.record.answers

                if isViewLoaded {
                    tableView?.reloadData()
                }
            }
        }
    }

    fileprivate(set) var answers = Answers()
}


extension AnswersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tableView = tableView {
            if view != tableView && view != tableView.superview {
                view.addSubview(tableView)
                tableView.removeConstraints(tableView.constraints)
                tableView.translatesAutoresizingMaskIntoConstraints = true
                tableView.frame = view.bounds
                tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            }

            cellSource.register(in: tableView)
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
        becomeFirstResponder()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveRecord()
        resignFirstResponder()
    }


    override var canBecomeFirstResponder: Bool {
        return true
    }
}


extension AnswersViewController {
    func setAnswer(_ answer: AnswerType, for statement: Statement) {
        guard let record = viewModel?.record else {
            return
        }

        answers = answers.settingAnswer(answer, for: statement.identifier)
        inputDelegate?.answersViewController(self, didSet: answer, for: statement, record: record)
    }
}


extension AnswersViewController {
    fileprivate func saveRecord() {
        guard let record = viewModel?.record else {
            return
        }

        inputDelegate?.answersInputViewController(self, didSet: answers, for: record)
    }
}


// MARK: - UITableViewDataSource
extension AnswersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.statementsCount ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellSource.dequeue(from: tableView, for: indexPath, with: viewModel?.statement(at: indexPath.row)
            .map { ($0, answers.answer(for: $0.identifier)) })
    }
}


extension AnswersViewController {
    @IBAction func handleStatementCellSegmentedControlChanged(_ sender: Any?) {
        guard let segmentedControl = sender as? UISegmentedControl, let tableView = tableView else {
            return
        }

        let touchPoint = tableView.convert(segmentedControl.center, from: segmentedControl.superview)

        guard let indexPath = tableView.indexPathForRow(at: touchPoint), let statement = viewModel?.statement(at: indexPath.row) else {
            return
        }

        switch segmentedControl.selectedSegmentIndex {
        case 0: setAnswer(.negative, for: statement)
        case 1: setAnswer(.positive, for: statement)
        default: setAnswer(.unknown, for: statement)
        }
    }
}
