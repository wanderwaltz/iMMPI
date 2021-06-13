import Foundation
import Localization

extension ComputedScoreFormatter {
    static let `default` = ComputedScoreFormatter({ String(describing: $0) })

    static let filtered = ComputedScoreFormatter({ score in
        if score.isWithinNorm {
            return Strings.Analysis.normalScorePlaceholder
        }
        else {
            return ComputedScoreFormatter.default.format(score)
        }
    })
}
