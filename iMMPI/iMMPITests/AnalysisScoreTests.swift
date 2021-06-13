import XCTest
import DataModel
@testable import iMMPI

final class AnalysisScoreTests: XCTestCase {
    func testThat__it_uses_the_appropriate_gender_when_reading_value__case_1() {
        var receivedGender: Gender! = nil

        let score = AnalysisScore(value: .specific({ gender in { _ in
            receivedGender = gender
            return 0.0
            }}))

        let answers = Answers()

        _ = score.value(for: .male, answers: answers)
        XCTAssertEqual(receivedGender, .male)

        _ = score.value(for: .female, answers: answers)
        XCTAssertEqual(receivedGender, .female)

        _ = score.value(for: .unknown, answers: answers)
        XCTAssertEqual(receivedGender, .male)
    }


    func testThat__it_uses_the_appropriate_gender_when_reading_value__case_2() {
        var receivedGender: Gender! = nil

        let score = AnalysisScore(value: .specific({ gender in { _ in
            receivedGender = gender
            return 0.0
            }}))

        let maleRecord = Record(person: Person(gender: .male))
        let femaleRecord = Record(person: Person(gender: .female))
        let unknownRecord = Record(person: Person(gender: .unknown))

        _ = score.value(for: maleRecord)
        XCTAssertEqual(receivedGender, .male)

        _ = score.value(for: femaleRecord)
        XCTAssertEqual(receivedGender, .female)

        _ = score.value(for: unknownRecord)
        XCTAssertEqual(receivedGender, .male)
    }


    func testThat__it_returns_the_block_value__case_1() {
        let score = AnalysisScore(value: .specific({ gender in { _ in
            switch gender {
            case .male: return 0.0
            case .female: return 1.0
            case .unknown: return 3.0
            }
            }}))

        let answers = Answers()

        XCTAssertEqual(score.value(for: .male, answers: answers), 0.0)
        XCTAssertEqual(score.value(for: .female, answers: answers), 1.0)
        XCTAssertEqual(score.value(for: .unknown, answers: answers), 0.0)
    }


    func testThat__it_returns_the_block_value__case_2() {
        let score = AnalysisScore(value: .specific({ gender in { _ in
            switch gender {
            case .male: return 0.0
            case .female: return 1.0
            case .unknown: return 3.0
            }
            }}))

        let maleRecord = Record(person: Person(gender: .male))
        let femaleRecord = Record(person: Person(gender: .female))
        let unknownRecord = Record(person: Person(gender: .unknown))

        XCTAssertEqual(score.value(for: maleRecord), 0.0)
        XCTAssertEqual(score.value(for: femaleRecord), 1.0)
        XCTAssertEqual(score.value(for: unknownRecord), 0.0)
    }


    func testThat__it_forwards_answers_to_block__case_1() {
        var receivedAnswers: Answers!

        let score = AnalysisScore(value: .specific({ _ in {
            receivedAnswers = $0
            return 0.0
            }}))

        let answers = Answers()

        _ = score.value(for: .male, answers: answers)
        XCTAssertTrue(receivedAnswers == answers)
        receivedAnswers = nil

        _ = score.value(for: .female, answers: answers)
        XCTAssertTrue(receivedAnswers == answers)
        receivedAnswers = nil

        _ = score.value(for: .unknown, answers: answers)
        XCTAssertTrue(receivedAnswers == answers)
        receivedAnswers = nil
    }


    func testThat__it_forwards_answers_to_block__case_2() {
        var receivedAnswers: Answers!

        let score = AnalysisScore(value: .specific({ _ in {
            receivedAnswers = $0
            return 0.0
            }}))

        let maleRecord = Record(person: Person(gender: .male))
        let femaleRecord = Record(person: Person(gender: .female))
        let unknownRecord = Record(person: Person(gender: .unknown))
        
        _ = score.value(for: maleRecord)
        XCTAssertTrue(receivedAnswers == maleRecord.answers)
        receivedAnswers = nil

        _ = score.value(for: femaleRecord)
        XCTAssertTrue(receivedAnswers == femaleRecord.answers)
        receivedAnswers = nil

        _ = score.value(for: unknownRecord)
        XCTAssertTrue(receivedAnswers == unknownRecord.answers)
        receivedAnswers = nil
    }
}
