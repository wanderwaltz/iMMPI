import UIKit

/// A base class for presenting and editing RecordProtocol record answers in a UITableView-driven UI.
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
class TestAnswersViewController: UIViewController, UsingRouting {
    weak var inputDelegate: TestAnswersInputDelegate?

    var cellSource = StatementTableViewCell.makeSourceForReview()

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


extension TestAnswersViewController {
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
        viewModel?.setNeedsUpdate()
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


extension TestAnswersViewController {
    func setAnswer(_ answer: AnswerType, for statement: Statement) {
        guard let record = viewModel?.record else {
            return
        }

        answers.setAnswer(answer, for: statement.identifier)
        inputDelegate?.testAnswersViewController(self, didSet: answer, for: statement, record: record)
    }
}


extension TestAnswersViewController {
    fileprivate func saveRecord() {
        guard let record = viewModel?.record else {
            return
        }

        inputDelegate?.testAnswersInputViewController(self, didSet: answers, for: record)
    }
}


// MARK: - UITableViewDataSource
extension TestAnswersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.statementsCount ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellSource.dequeue(from: tableView, with: viewModel?.statement(at: indexPath.row)
            .map { ($0, answers.answer(for: $0.identifier)) })
    }
}


extension TestAnswersViewController {
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
