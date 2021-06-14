import Foundation
import DataModel
import MMPITestAnswersUI
import MMPISoundPlayer

extension SoundPlayer: AnswersInputDelegate {
    public func answersViewController(
        _ controller: AnswersViewController,
        didSet answer: AnswerType,
        for statement: Statement,
        record: RecordProtocol
    ) {
        switch answer {
        case .positive: play(.clickPositive)
        case .negative: play(.clickNegative)
        case .unknown: break
        }
    }
}
