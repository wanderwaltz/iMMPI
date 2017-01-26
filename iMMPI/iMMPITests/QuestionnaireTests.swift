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
        XCTAssert(try Questionnaire(gender: .unknown, ageGroup: .adult), throws: .nilFileName)
        XCTAssert(try Questionnaire(gender: .unknown, ageGroup: .teen), throws: .nilFileName)
        XCTAssert(try Questionnaire(gender: .male, ageGroup: .unknown), throws: .nilFileName)
        XCTAssert(try Questionnaire(gender: .female, ageGroup: .unknown), throws: .nilFileName)
        XCTAssert(try Questionnaire(gender: .unknown, ageGroup: .unknown), throws: .nilFileName)

        XCTAssert(try Questionnaire(resourceName: "invalid"), throws: .fileNotFound)

        let bundle = Bundle(for: type(of: self))

        XCTAssert(try Questionnaire(resourceName: "questionnaire.error.jsonRootNotDictionary", bundle: bundle),
                  throws: .jsonRootNotDictionary)

        XCTAssert(try Questionnaire(resourceName: "questionnaire.error.statementsNotFound", bundle: bundle),
                  throws: .statementsNotFound)

        XCTAssert(try Questionnaire(resourceName: "questionnaire.error.statementJsonNotDictionary", bundle: bundle),
                  throws: .statementJsonNotDictionary)

        XCTAssert(try Questionnaire(resourceName: "questionnaire.error.statementIdentifierNotFound", bundle: bundle),
                  throws: .statementIdentifierNotFound)

        XCTAssert(try Questionnaire(resourceName: "questionnaire.error.statementTextNotFound", bundle: bundle),
                  throws: .statementTextNotFound)
    }

    func testThat__default_questionnaires_have_statement_ids_corresponding_to_indexes() {
        for questionnaire in validQuestionnaires {
            for index in 0..<questionnaire.statementsCount {
                XCTAssertEqual(questionnaire.statement(at: index)!.statementID, Int(index)+1)
            }

            for index in 0..<questionnaire.statementsCount {
                XCTAssertTrue(questionnaire.statement(at: index)! == questionnaire.statement(id: index+1)!)
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


fileprivate func XCTAssert<T>(_ code: @autoclosure () throws -> T, throws error: Questionnaire.Error,
                           file: StaticString = #file, line: UInt = #line) {
    var receivedError: Error? = nil

    do {
        _ = try code()
    }
    catch let e {
        receivedError = e
    }

    XCTAssertNotNil(receivedError, "Expected to throw an error", file: file, line: line)

    XCTAssertTrue(receivedError! is Questionnaire.Error,
                  "Expected to throw Questionnaire.Error, got \(receivedError!) instead", file: file, line: line)

    XCTAssertTrue((receivedError! as! Questionnaire.Error) ~= error,
                  "Expected to throw \(error), got \(receivedError!) instead", file: file, line: line)
}
