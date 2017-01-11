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

    /// A `TestRecordProtocol` object to be managed by the view controller.
    ///
    /// This property should be set prior to showing the view contorller's view on screen, 
    /// so the questionnaire can be properly set up (questionnaire depends on the `PersonProtocol` 
    /// object properties which are retrieved from the record).
    var record: TestRecordProtocol?

    /// A storage for the `TestRecordProtocol` record.
    ///
    /// Records managed by the `TestAnswersTableViewControllerBase` are assumed to be stored in the 
    /// `TestRecordStorage` object provided in this property. When saving state of the record, 
    /// the `update(_:)` method is called on the provided storage object.
    var storage: TestRecordStorage?

    /// The QuestionnaireProtocol object which provides the questionnaire info.
    ///
    /// If this property is not set manually, it can be set automatically using the 
    /// `loadQuestionnaireAsyncIfNeeded(_:)` method.
    var questionnaire: Questionnaire?
}


extension TestAnswersTableViewControllerBase {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadQuestionnaireAsyncIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveRecord()
    }
}


extension TestAnswersTableViewControllerBase {
    func setAnswer(_ answer: AnswerType, for statement: Statement) {
        guard let record = record else {
            return
        }

        record.testAnswers.setAnswer(answer, for: statement.statementID)
        inputDelegate?.testAnswersViewController(self, didSet: answer, for: statement, record: record)
    }


    /// Loads the questionnaire asynchronously if questionnaire property value is nil.
    ///
    /// Creates a new `Questionnaire` object depending on the values of the `PersonProtocol` 
    /// object read from the record property.
    ///
    /// This method does nothing if record property value is nil.
    func loadQuestionnaireAsyncIfNeeded() {
        if let record = record, questionnaire == nil {
            DispatchQueue.global().async {
                let questionnaire = try? Questionnaire(gender: record.person.gender, ageGroup: record.person.ageGroup)

                DispatchQueue.main.async {
                    self.questionnaire = questionnaire
                    self.tableView?.reloadData()
                }
            }
        }
    }


    /// Updates the record in the storage object provided.
    func saveRecord() {
        if let record = record {
            storage?.update(record)
        }
    }
}



// MARK: - UITableViewDataSource
extension TestAnswersTableViewControllerBase: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionnaire?.statementsCount ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatementTableViewCell.reuseIdentifier())
            as! StatementTableViewCell

        cell.delegate = self

        if let statement = questionnaire?.statement(at: indexPath.row) {
            cell.statementIDLabel?.text = "\(statement.statementID)"
            cell.statementTextLabel?.text = statement.text

            switch record?.testAnswers.answer(for: statement.statementID) ?? .unknown {
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
        if let indexPath = tableView?.indexPath(for: cell), let statement = questionnaire?.statement(at: indexPath.row) {
            switch selectedSegmentIndex {
            case 0: setAnswer(.negative, for: statement)
            case 1: setAnswer(.positive, for: statement)
            default: setAnswer(.unknown, for: statement)
            }
        }
    }
}
