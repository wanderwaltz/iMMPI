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
    /// Loads the questionnaire asynchronously if questionnaire property value is nil.
    ///
    /// Creates a new `Questionnaire` object depending on the values of the `PersonProtocol` 
    /// object read from the record property. The questionnaire is loaded asynchronously 
    /// in background and a completion callback block is dispatched on main queue then.
    ///
    /// This method does nothing if record property value is nil.
    ///
    /// - Parameter completion: A block to be dispatched on main queue when the questionnaire is loaded.
    func loadQuestionnaireAsyncIfNeeded(completion: @escaping () -> ()) {
        if let record = record, questionnaire == nil {
            DispatchQueue.global().async {
                let questionnaire = try? Questionnaire(gender: record.person.gender, ageGroup: record.person.ageGroup)

                DispatchQueue.main.async {
                    self.questionnaire = questionnaire
                    completion()
                }
            }
        }
    }


    /// A default variant of the -loadQuestionnaireAsyncIfNeeded: method which calls 
    /// `reloadData()` on the table view when the questionnaire finishes loading.
    func loadQuestionnaireAsyncIfNeeded() {
        loadQuestionnaireAsyncIfNeeded {
            self.tableView?.reloadData()
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
            case 0: record?.testAnswers.setAnswer(.negative, for: statement.statementID)
            case 1: record?.testAnswers.setAnswer(.positive, for: statement.statementID)
            default: record?.testAnswers.setAnswer(.unknown, for: statement.statementID)
            }
        }
    }
}
