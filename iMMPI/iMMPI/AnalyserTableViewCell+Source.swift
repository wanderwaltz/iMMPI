import Foundation

extension AnalyserTableViewCell {
    typealias Source = TableViewCellSource<Data>
    typealias Data = (scale: AnalysisScale, record: TestRecordProtocol)

    static func makeSource(with style: Style = .default(with: UserDefaultsAnalysisSettings())) -> Source {
        return .nib(
            update: { (cell: AnalyserTableViewCell, data: Data?) in
                guard let data = data else {
                    return
                }

                let scale = data.scale
                let record = data.record
                let nesting = scale.identifier.nesting

                cell.groupNameLabel?.text = scale.title
                cell.groupNameLabel?.font = style.font(with: nesting)
                cell.groupNameOffset = style.groupNameOffset(with: nesting)

                cell.scoreLabel?.font = style.font(with: nesting)
                cell.scoreLabel?.text = style.formatScore(for: scale, record: record)

                cell.indexLabel?.text = style.formatIndex(scale.index.value(for: record))
        })
    }
}


extension AnalyserTableViewCell {
    struct Style {
        init(fontWithNesting: @escaping (Int) -> UIFont,
             groupNameOffsetWithNesting: @escaping (Int) -> CGFloat,
             indexFormatter: @escaping (Int) -> String,
             scoreFormatter: @escaping (AnalysisScale, TestRecordProtocol) -> String) {
            _fontWithNesting = fontWithNesting
            _groupNameOffsetWithNesting = groupNameOffsetWithNesting
            _indexFormatter = indexFormatter
            _scoreFormatter = scoreFormatter
        }

        func font(with nesting: Int) -> UIFont {
            return _fontWithNesting(nesting)
        }

        func groupNameOffset(with nesting: Int) -> CGFloat {
            return _groupNameOffsetWithNesting(nesting)
        }

        func formatIndex(_ index: Int) -> String {
            return _indexFormatter(index)
        }

        func formatScore(for scale: AnalysisScale, record: TestRecordProtocol) -> String {
            return _scoreFormatter(scale, record)
        }

        private let _fontWithNesting: (Int) -> UIFont
        private let _groupNameOffsetWithNesting: (Int) -> CGFloat
        private let _indexFormatter: (Int) -> String
        private let _scoreFormatter: (AnalysisScale, TestRecordProtocol) -> String
    }
}


extension AnalyserTableViewCell.Style {
    static func `default`(with settings: AnalysisSettings) -> AnalyserTableViewCell.Style {
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

        let style = AnalyserTableViewCell.Style(
            fontWithNesting: {
                switch effectiveNesting($0) {
                case 0: return .boldSystemFont(ofSize: 18.0)
                case 1: return .systemFont(ofSize: 18.0)
                default: return .italicSystemFont(ofSize: 16.0)
                }
            },
            groupNameOffsetWithNesting: { nesting in
                return CGFloat(effectiveNesting(nesting) * 40)
            },
            indexFormatter: {
                $0 > 0 ? "\($0)." : ""
            },
            scoreFormatter: { scale, record in
                let score = scale.score.value(for: record)
                if settings.shouldFilterResults && scale.filter.isWithinNorm(score) {
                    return Strings.Analysis.normalScorePlaceholder
                }
                else {
                    return scale.formatter.format(score)
                }
            })

        return style
    }
}
