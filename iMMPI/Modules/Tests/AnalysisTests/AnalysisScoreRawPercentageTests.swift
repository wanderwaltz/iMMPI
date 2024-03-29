import XCTest
import DataModel
@testable import Analysis

final class AnalysisScoreRawPercentageTests: XCTestCase {
    func testThat__it_computes_number_of_matches__case_1() {
        let score = AnalysisScore.rawPercentage(.common((positive: [1, 2, 5], negative: [3, 7, 8])))
        let answers = Answers(positive: [1, 2, 5], negative: [3, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: answers).score, 100.0)
        XCTAssertEqual(score.value(for: .female, answers: answers).score, 100.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers).score, 100.0)
    }


    func testThat__it_computes_number_of_matches__case_2() {
        let score = AnalysisScore.rawPercentage(.common((positive: [1, 2, 5], negative: [7, 8])))
        let answers = Answers(positive: [1], negative: [2, 3, 5, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: answers).score, 60.0)
        XCTAssertEqual(score.value(for: .female, answers: answers).score, 60.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers).score, 60.0)
    }


    func testThat__it_computes_number_of_matches__case_3() {
        let score = AnalysisScore.rawPercentage(.common((positive: [1, 2, 5], negative: [3, 7, 8])))
        let answers = Answers()

        XCTAssertEqual(score.value(for: .male, answers: answers).score, 0.0)
        XCTAssertEqual(score.value(for: .female, answers: answers).score, 0.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers).score, 0.0)
    }


    func testThat__it_computes_gender_based_number_of_matches() {
        let score = AnalysisScore.rawPercentage(.specific(
            male: (positive: [1, 2, 5], negative: [3, 7, 8]),
            female: (positive: [], negative: [1, 2, 3, 5])
            ))

        let answers = Answers(positive: [1, 2, 5], negative: [3, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: answers).score, 100.0)
        XCTAssertEqual(score.value(for: .female, answers: answers).score, 25.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers).score, 100.0)
    }


    func testThat__it_returns_100_percent_when_initialized_with_empty_arrays() {
        let score = AnalysisScore.rawPercentage(.common((positive: [], negative: [])))
        let emptyAnswers = Answers()
        let someAnswers = Answers(positive: [1, 2, 5], negative: [3, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: emptyAnswers).score, 100.0)
        XCTAssertEqual(score.value(for: .female, answers: emptyAnswers).score, 100.0)
        XCTAssertEqual(score.value(for: .unknown, answers: emptyAnswers).score, 100.0)

        XCTAssertEqual(score.value(for: .male, answers: someAnswers).score, 100.0)
        XCTAssertEqual(score.value(for: .female, answers: someAnswers).score, 100.0)
        XCTAssertEqual(score.value(for: .unknown, answers: someAnswers).score, 100.0)
    }
}
