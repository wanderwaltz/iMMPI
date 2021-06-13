import UIKit
import Analysis
import AnalysisSettings

extension AnalysisScaleCollectionViewCell {
    typealias Source = CollectionViewCellSource<BoundScale>

    static func makeSource(
        with style: AnalyserCellStyle = .default(
            with: UserDefaultsAnalysisSettings()
        )
    ) -> Source {
        return .nib { (cell: AnalysisScaleCollectionViewCell, scale: BoundScale?) in
            style.apply(to: cell, with: scale)
        }
    }
}
