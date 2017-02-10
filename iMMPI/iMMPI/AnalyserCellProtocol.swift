import UIKit

protocol AnalyserCellProtocol: class {
    var indexLabel: UILabel? { get }
    var titleLabel: UILabel? { get }
    var scoreLabel: UILabel? { get }

    var titleOffset: CGFloat { get set }
}


struct AnalyserCellStyle {
    init(fontWithNesting: @escaping (Int) -> UIFont,
         titleOffsetWithNesting: @escaping (Int) -> CGFloat,
         indexFormatter: @escaping (Int) -> String,
         scoreFormatter: @escaping (BoundScale) -> String) {
        _fontWithNesting = fontWithNesting
        _titleOffsetWithNesting = titleOffsetWithNesting
        _indexFormatter = indexFormatter
        _scoreFormatter = scoreFormatter
    }

    func font(with nesting: Int) -> UIFont {
        return _fontWithNesting(nesting)
    }

    func titleOffset(with nesting: Int) -> CGFloat {
        return _titleOffsetWithNesting(nesting)
    }

    func formatIndex(_ index: Int) -> String {
        return _indexFormatter(index)
    }

    func formatScore(for scale: BoundScale) -> String {
        return _scoreFormatter(scale)
    }

    private let _fontWithNesting: (Int) -> UIFont
    private let _titleOffsetWithNesting: (Int) -> CGFloat
    private let _indexFormatter: (Int) -> String
    private let _scoreFormatter: (BoundScale) -> String
}


extension AnalyserCellStyle {
    func apply(to cell: AnalyserCellProtocol, with scale: BoundScale?) {
        guard let scale = scale else {
            return
        }

        let nesting = scale.identifier.nesting

        cell.titleLabel?.text = scale.title
        cell.titleLabel?.font = font(with: nesting)
        cell.titleOffset = titleOffset(with: nesting)

        cell.scoreLabel?.font = font(with: nesting)
        cell.scoreLabel?.text = formatScore(for: scale)

        cell.indexLabel?.text = formatIndex(scale.index)

    }
}


extension AnalyserCellStyle {
    static func `default`(with settings: AnalysisSettings) -> AnalyserCellStyle {
        let effectiveNesting: (Int) -> Int = { nesting in
            // If we hide the scores which are within the norm, there may be a situation
            // when the scale's parent scale is hidden, while the scale itself is not.
            //
            // In that case we'll have the offset of the child group still equal to
            // larger value and it will look like this scale is child to some other scale
            // which is wrong.
            //
            // So we reset all of the offsets if 'hide normal' setting
            // is set to on. Offset zero is reserved for the larger scales which are
            // always present, so we cap the offset at the value of 1
            if settings.shouldHideNormalResults && nesting > 1 {
                return 1
            }

            return nesting
        }

        let style = AnalyserCellStyle(
            fontWithNesting: {
                switch effectiveNesting($0) {
                case 0: return Fonts.scaleGroupTitle
                case 1: return Fonts.majorScaleTitle
                default: return Fonts.minorScaleTitle
                }
        },
            titleOffsetWithNesting: { nesting in
                return CGFloat(effectiveNesting(nesting) * 40)
        },
            indexFormatter: {
                $0 > 0 ? "\($0)." : ""
        },
            scoreFormatter: { scale in
                if settings.shouldFilterResults && scale.score.isWithinNorm {
                    return Strings.Analysis.normalScorePlaceholder
                }
                else {
                    return String(describing: scale.score)
                }
        })

        return style
    }
}
