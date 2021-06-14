import UIKit
import Analysis
import AnalysisSettings
import UIReusableViews

extension AnalysisScoreCollectionViewCell {
    public typealias Source = CollectionViewCellSource<BoundScale>

    public static func makeSource(
        with style: AnalyserCellStyle = .default(
            with: UserDefaultsAnalysisSettings()
        )
    ) -> Source {
        return .nib(
            bundle: .module,
            update: { (cell: AnalysisScoreCollectionViewCell, scale: BoundScale?) in
                style.apply(to: cell, with: scale)
            }
        )
    }
}
