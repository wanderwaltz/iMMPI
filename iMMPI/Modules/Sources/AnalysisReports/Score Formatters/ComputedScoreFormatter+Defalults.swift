import Foundation
import Localization

extension ComputedScoreFormatter {
    public static let `default` = ComputedScoreFormatter({ String(describing: $0) })

    public static let filtered = ComputedScoreFormatter({ score in
        if score.isWithinNorm {
            return Strings.Analysis.normalScorePlaceholder
        }
        else {
            return ComputedScoreFormatter.default.format(score)
        }
    })
}
