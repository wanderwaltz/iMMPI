import UIKit

extension AnalyserTableViewCell {
    typealias Source = TableViewCellSource<BoundScale>

    static func makeSource(with style: AnalyserCellStyle = .default(with: UserDefaultsAnalysisSettings())) -> Source {
        return .nib(update: { (cell: AnalyserTableViewCell, scale: BoundScale?) in style.apply(to: cell, with: scale) })
    }
}
