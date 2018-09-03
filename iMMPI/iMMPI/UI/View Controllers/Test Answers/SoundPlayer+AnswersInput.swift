import Foundation

extension SoundPlayer: AnswersInputDelegate {
    func answersViewController(_ controller: AnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: RecordProtocol) {
        switch answer {
        case .positive: play(.clickPositive)
        case .negative: play(.clickNegative)
        case .unknown: break
        }
    }
}
