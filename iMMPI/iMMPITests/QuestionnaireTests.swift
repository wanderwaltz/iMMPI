import XCTest
@testable import iMMPI

final class QuestionnaireTests: XCTestCase {
    lazy var validQuestionnaires: [Questionnaire] = {
        let result: [Questionnaire?] = [
            try? Questionnaire(gender: .female, ageGroup: .adult),
            try? Questionnaire(gender: .female, ageGroup: .teen),
            try? Questionnaire(gender: .male, ageGroup: .adult),
            try? Questionnaire(gender: .male, ageGroup: .teen)
        ]

        for questionnaire in result {
            XCTAssertNotNil(questionnaire)
            XCTAssertTrue(questionnaire?.statementsCount ?? 0 > 0)
        }

        return result.flatMap { $0 }
    }()

    func testThat__invalid_questionnaires_throw_when_initializing() {
        XCTAssertThrowsError(try Questionnaire(gender: .unknown, ageGroup: .adult))
        XCTAssertThrowsError(try Questionnaire(gender: .unknown, ageGroup: .teen))
        XCTAssertThrowsError(try Questionnaire(gender: .male, ageGroup: .unknown))
        XCTAssertThrowsError(try Questionnaire(gender: .female, ageGroup: .unknown))
        XCTAssertThrowsError(try Questionnaire(gender: .unknown, ageGroup: .unknown))
    }

    func testThat__default_questionnaires_have_statement_ids_corresponding_to_indexes() {
        for questionnaire in validQuestionnaires {
            for index in 0..<questionnaire.statementsCount {
                XCTAssertEqual(questionnaire.statement(at: index)!.statementID, Int(index)+1)
            }

            for index in 0..<questionnaire.statementsCount {
                XCTAssertTrue(questionnaire.statement(at: index)! === questionnaire.statement(id: index+1)!)
            }
        }
    }

    func testThat__all_valid_questionnaires_have_expected_number_of_statements() {
        for questionnaire in validQuestionnaires {
            XCTAssertEqual(questionnaire.statementsCount, 566)
        }
    }

    func testThat__statement_at_index_returns_nonnull_statement_for_valid_indexes() {
        for questionnaire in validQuestionnaires {
            for index in 0..<questionnaire.statementsCount {
                XCTAssertNotNil(questionnaire.statement(at: index))
            }
        }
    }

    func testThat__statement_by_id_returns_nonnull_statement_for_valid_ids() {
        for questionnaire in validQuestionnaires {
            for index in 0..<questionnaire.statementsCount {
                XCTAssertNotNil(questionnaire.statement(id: index+1))
            }
        }
    }

    func testThat__statement_at_index_returns_nil_for_invalid_indexes() {
        for questionnaire in validQuestionnaires {
            XCTAssertNil(questionnaire.statement(at: questionnaire.statementsCount))
            XCTAssertNil(questionnaire.statement(at: questionnaire.statementsCount+1))
            XCTAssertNil(questionnaire.statement(at: questionnaire.statementsCount+1))
        }
    }

    func testThat__statement_by_id_returns_nil_for_invalid_ids() {
        for questionnaire in validQuestionnaires {
            XCTAssertNil(questionnaire.statement(id: 0))
            XCTAssertNil(questionnaire.statement(id: questionnaire.statementsCount+2))
        }
    }

    func testThat__all_statements_in_valid_questionnaires_have_nonempty_text() {
        for questionnaire in validQuestionnaires {
            for index in 0..<questionnaire.statementsCount {
                XCTAssertFalse(questionnaire.statement(at: index)!.text.isEmpty)
            }
        }
    }
}
