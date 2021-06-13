import UIKit
import Analysis

extension AnalysisScoreCollectionViewCell {
    typealias Source = CollectionViewCellSource<BoundScale>

    static func makeSource(with style: AnalyserCellStyle = .default(with: UserDefaultsAnalysisSettings())) -> Source {
        return .nib(update: { (cell: AnalysisScoreCollectionViewCell, scale: BoundScale?) in
            style.apply(to: cell, with: scale)
        })
    }
}
