import UIKit
import Analysis
import AnalysisSettings
import UIReusableViews

extension AnalysisScoreCollectionViewCell {
    typealias Source = CollectionViewCellSource<BoundScale>

    static func makeSource(
        with style: AnalyserCellStyle = .default(
            with: UserDefaultsAnalysisSettings()
        )
    ) -> Source {
        return .nib { (cell: AnalysisScoreCollectionViewCell, scale: BoundScale?) in
            style.apply(to: cell, with: scale)
        }
    }
}
