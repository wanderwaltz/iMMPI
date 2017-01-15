import Foundation

final class AnalysisOptionsViewModel {
    typealias SwitchCellData = (title: String, value: Bool)

    var onDidUpdate: (Section<SwitchCellData>) -> () = Constant.void()

    init(settings: AnalysisSettings) {
        self.settings = settings
    }

    fileprivate let settings: AnalysisSettings
    fileprivate var switchRows: Section<SwitchCellData>!
}


extension AnalysisOptionsViewModel {
    func setNeedsUpdate() {
        var switchRows: [SwitchCellData] = [
            (title: Strings.filterResults, value: settings.shouldFilterResults)
        ]

        if settings.shouldFilterResults {
            switchRows.append((title: Strings.hideNormalResults, value: settings.shouldHideNormalResults))
        }

        self.switchRows = Section(title: "", items: switchRows)
        onDidUpdate(self.switchRows)
    }
}


extension AnalysisOptionsViewModel {
    func toggleSwitch(atIndex index: Int) {
        switch index {
        case 0:
            settings.shouldFilterResults = !settings.shouldFilterResults

        case 1:
            settings.shouldHideNormalResults = !settings.shouldHideNormalResults

        default:
            break
        }

        setNeedsUpdate()
    }
}
