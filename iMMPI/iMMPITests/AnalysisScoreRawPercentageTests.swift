import XCTest
@testable import iMMPI

final class AnalysisScoreRawPercentageTests: XCTestCase {
    func testThat__it_computes_number_of_matches__case_1() {
        let score = AnalysisScore.rawPercentage(.common((positive: [1, 2, 5], negative: [3, 7, 8])))

        let answers = TestAnswers()
        answers.setAnswers(positive: [1, 2, 5], negative: [3, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: answers), 1.0)
        XCTAssertEqual(score.value(for: .female, answers: answers), 1.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers), 1.0)
    }


    func testThat__it_computes_number_of_matches__case_2() {
        let score = AnalysisScore.rawPercentage(.common((positive: [1, 2, 5], negative: [3, 7, 8])))

        let answers = TestAnswers()
        answers.setAnswers(positive: [1], negative: [2, 3, 5, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: answers), 4.0 / 6.0)
        XCTAssertEqual(score.value(for: .female, answers: answers), 4.0 / 6.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers), 4.0 / 6.0)
    }


    func testThat__it_computes_number_of_matches__case_3() {
        let score = AnalysisScore.rawPercentage(.common((positive: [1, 2, 5], negative: [3, 7, 8])))

        let answers = TestAnswers()
        answers.setAnswers(positive: [], negative: [])

        XCTAssertEqual(score.value(for: .male, answers: answers), 0.0)
        XCTAssertEqual(score.value(for: .female, answers: answers), 0.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers), 0.0)
    }


    func testThat__it_computes_gender_based_number_of_matches() {
        let score = AnalysisScore.rawPercentage(.specific(
            male: (positive: [1, 2, 5], negative: [3, 7, 8]),
            female: (positive: [], negative: [1, 2, 3])
            ))

        let answers = TestAnswers()
        answers.setAnswers(positive: [1, 2, 5], negative: [3, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: answers), 1.0)
        XCTAssertEqual(score.value(for: .female, answers: answers), 1.0 / 3.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers), 1.0)
    }


    func testThat__it_returns_100_percent_when_initialized_with_empty_arrays() {
        let score = AnalysisScore.rawPercentage(.common((positive: [], negative: [])))

        let emptyAnswers = TestAnswers()
        emptyAnswers.setAnswers(positive: [], negative: [])

        let someAnswers = TestAnswers()
        someAnswers.setAnswers(positive: [1, 2, 5], negative: [3, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: emptyAnswers), 1.0)
        XCTAssertEqual(score.value(for: .female, answers: emptyAnswers), 1.0)
        XCTAssertEqual(score.value(for: .unknown, answers: emptyAnswers), 1.0)

        XCTAssertEqual(score.value(for: .male, answers: someAnswers), 1.0)
        XCTAssertEqual(score.value(for: .female, answers: someAnswers), 1.0)
        XCTAssertEqual(score.value(for: .unknown, answers: someAnswers), 1.0)
    }
}
