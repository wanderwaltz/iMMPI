import XCTest
import DataModel

final class AnswerTypeTests: XCTestCase {
    var descriptions: [AnswerType:String]!

    override func setUp() {
        super.setUp()
        descriptions = [
            AnswerType.positive: AnswerType.positive.description,
            AnswerType.negative: AnswerType.negative.description,
            AnswerType.unknown: AnswerType.unknown.description
        ]
    }

    func testThat__answerType__descriptions__are_distinct() {
        XCTAssertEqual(descriptions.count, Set(descriptions.values).count)
    }


    func testThat__answerType__descriptions__are_nonempty() {
        for description in descriptions.values {
            XCTAssertFalse(description.isEmpty)
        }
    }
}
