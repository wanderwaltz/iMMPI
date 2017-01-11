import Foundation

extension SoundPlayer: TestAnswersInputDelegate {
    func testAnswersViewController(_ controller: TestAnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: TestRecordProtocol) {
        switch answer {
        case .positive: play(.clickPositive)
        case .negative: play(.clickNegative)
        case .unknown: break
        }
    }
}
