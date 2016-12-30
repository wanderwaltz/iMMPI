import XCTest
@testable import iMMPI

final class QuestionnaireTests: XCTestCase {
    lazy var validQuestionnaires: [Questionnaire] = {
        let result: [Questionnaire?] = [
            Questionnaire(gender: .female, ageGroup: .adult),
            Questionnaire(gender: .female, ageGroup: .teen),
            Questionnaire(gender: .male, ageGroup: .adult),
            Questionnaire(gender: .male, ageGroup: .teen)
        ]

        for questionnaire in result {
            XCTAssertNotNil(questionnaire)
            XCTAssertTrue(questionnaire?.statementsCount() ?? 0 > 0)
        }

        return result.flatMap { $0 }
    }()

    func testThat__default_questionnaires_have_statement_ids_corresponding_to_indexes() {
        for questionnaire in validQuestionnaires {
            for index in 0..<questionnaire.statementsCount() {
                XCTAssertEqual(questionnaire.statement(at: index)!.statementID, Int(index)+1)
            }

            for index in 0..<questionnaire.statementsCount() {
                XCTAssertTrue(questionnaire.statement(at: index)! === questionnaire.statement(withID: index+1)!)
            }
        }
    }

    func testThat__all_valid_questionnaires_have_expected_number_of_statements() {
        for questionnaire in validQuestionnaires {
            XCTAssertEqual(questionnaire.statementsCount(), 566)
        }
    }

    func testThat__statement_at_index_returns_nonnull_statement_for_valid_indexes() {
        for questionnaire in validQuestionnaires {
            for index in 0..<questionnaire.statementsCount() {
                XCTAssertNotNil(questionnaire.statement(at: index))
            }
        }
    }

    func testThat__statement_by_id_returns_nonnull_statement_for_valid_ids() {
        for questionnaire in validQuestionnaires {
            for index in 0..<questionnaire.statementsCount() {
                XCTAssertNotNil(questionnaire.statement(withID: index+1))
            }
        }
    }

    func testThat__statement_at_index_returns_nil_for_invalid_indexes() {
        for questionnaire in validQuestionnaires {
            XCTAssertNil(questionnaire.statement(at: questionnaire.statementsCount()))
            XCTAssertNil(questionnaire.statement(at: questionnaire.statementsCount()+1))
            XCTAssertNil(questionnaire.statement(at: questionnaire.statementsCount()+1))
        }
    }

    func testThat__statement_by_id_returns_nil_for_invalid_ids() {
        for questionnaire in validQuestionnaires {
            XCTAssertNil(questionnaire.statement(withID: 0))
            XCTAssertNil(questionnaire.statement(withID: questionnaire.statementsCount()+2))
        }
    }

    func testThat__all_statements_in_valid_questionnaires_have_nonempty_text() {
        for questionnaire in validQuestionnaires {
            for index in 0..<questionnaire.statementsCount() {
                XCTAssertFalse(questionnaire.statement(at: index)!.text.isEmpty)
            }
        }
    }
}
