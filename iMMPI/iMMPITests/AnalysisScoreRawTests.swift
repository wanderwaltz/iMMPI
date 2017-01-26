import XCTest
@testable import iMMPI

final class AnalysisScoreRawTests: XCTestCase {
    func testThat__it_computes_number_of_matches__case_1() {
        let score = AnalysisScore.raw(.common((positive: [1, 2, 5], negative: [3, 7, 8])))

        let answers = Answers()
        answers.setAnswers(positive: [1, 2, 5], negative: [3, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: answers), 6.0)
        XCTAssertEqual(score.value(for: .female, answers: answers), 6.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers), 6.0)
    }


    func testThat__it_computes_number_of_matches__case_2() {
        let score = AnalysisScore.raw(.common((positive: [1, 2, 5], negative: [3, 7, 8])))

        let answers = Answers()
        answers.setAnswers(positive: [1], negative: [2, 3, 5, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: answers), 4.0)
        XCTAssertEqual(score.value(for: .female, answers: answers), 4.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers), 4.0)
    }


    func testThat__it_computes_number_of_matches__case_3() {
        let score = AnalysisScore.raw(.common((positive: [1, 2, 5], negative: [3, 7, 8])))

        let answers = Answers()
        answers.setAnswers(positive: [], negative: [])

        XCTAssertEqual(score.value(for: .male, answers: answers), 0.0)
        XCTAssertEqual(score.value(for: .female, answers: answers), 0.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers), 0.0)
    }


    func testThat__it_computes_gender_based_number_of_matches() {
        let score = AnalysisScore.raw(.specific(
            male: (positive: [1, 2, 5], negative: [3, 7, 8]),
            female: (positive: [], negative: [1, 2, 3])
            ))

        let answers = Answers()
        answers.setAnswers(positive: [1, 2, 5], negative: [3, 7, 8])

        XCTAssertEqual(score.value(for: .male, answers: answers), 6.0)
        XCTAssertEqual(score.value(for: .female, answers: answers), 1.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers), 6.0)
    }
}
