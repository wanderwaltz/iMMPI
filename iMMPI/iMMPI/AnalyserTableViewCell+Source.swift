import Foundation

extension AnalyserTableViewCell {
    typealias Source = TableViewCellSource<Data>
    typealias Data = (group: AnalyzerGroup, record: TestRecordProtocol, depth: Int)

    static func makeSource(with style: Style = .default) -> Source {
        return .nib(
            update: { (cell: AnalyserTableViewCell, data: Data?) in
                guard let data = data else {
                    return
                }

                let group = data.group
                let record = data.record
                let depth = data.depth

                cell.groupNameLabel?.text = group.name
                cell.groupNameLabel?.font = style.font(with: depth)
                cell.groupNameOffset = style.groupNameOffset(with: depth)

                cell.scoreLabel?.font = style.font(with: depth)
                cell.scoreLabel?.text = style.formatScore(for: group)

                cell.indexLabel?.text = style.formatIndex(group.index(forRecord: record))
        })
    }
}


extension AnalyserTableViewCell {
    struct Style {
        init(fontWithDepth: @escaping (Int) -> UIFont,
             groupNameOffsetWithDepth: @escaping (Int) -> CGFloat,
             indexFormatter: @escaping (Int) -> String,
             scoreFormatter: @escaping (AnalyzerGroup) -> String) {
            _fontWithDepth = fontWithDepth
            _groupNameOffsetWithDepth = groupNameOffsetWithDepth
            _indexFormatter = indexFormatter
            _scoreFormatter = scoreFormatter
        }

        func font(with depth: Int) -> UIFont {
            return _fontWithDepth(depth)
        }

        func groupNameOffset(with depth: Int) -> CGFloat {
            return _groupNameOffsetWithDepth(depth)
        }

        func formatIndex(_ index: Int) -> String {
            return _indexFormatter(index)
        }

        func formatScore(for group: AnalyzerGroup) -> String {
            return _scoreFormatter(group)
        }

        private let _fontWithDepth: (Int) -> UIFont
        private let _groupNameOffsetWithDepth: (Int) -> CGFloat
        private let _indexFormatter: (Int) -> String
        private let _scoreFormatter: (AnalyzerGroup) -> String
    }
}


extension AnalyserTableViewCell.Style {
    static let `default`: AnalyserTableViewCell.Style =  {
        // TODO: make dependency on AnalysisSettings explicit
        let shouldFilterResults = AnalysisSettings.shouldFilterAnalysisResults()
        let shouldHideNormalResults = AnalysisSettings.shouldHideNormalResults()

        let effectiveDepth: (Int) -> Int = { depth in
            // If we hide the scores which are within the norm, there may be a situation
            // when the group's parent group is hidden, while the group itself is not.
            // In that case we'll have the offset of the child group still equal to
            // larger value and it will look like this group is child to some other group
            // which is wrong. So we reset all of the offsets if 'hide normal' setting
            // is set to on. Offset zero is reserved for the larger groups which are
            // always present, so we cap the offset at the value of 1
            if shouldHideNormalResults && depth > 1 {
                return 1
            }

            return depth
        }

        let style = AnalyserTableViewCell.Style(
            fontWithDepth: { depth in
                switch effectiveDepth(depth) {
                case 0: return .boldSystemFont(ofSize: 18.0)
                case 1: return .systemFont(ofSize: 18.0)
                default: return .italicSystemFont(ofSize: 16.0)
                }
            },
            groupNameOffsetWithDepth: { depth in
                return CGFloat(effectiveDepth(depth) * 40)
            },
            indexFormatter: {
                $0 > 0 ? "\($0)." : ""
            },
            scoreFormatter: { group in
                if shouldFilterResults && group.scoreIsWithinNorm() {
                    return Strings.normalScorePlaceholder
                }
                else {
                    return group.readableScore()
                }
            })

        return style
    }()
}
