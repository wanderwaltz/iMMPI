import Foundation

final class ValidatingAnalysisSettings {
    init(_ base: AnalysisSettings) {
        self.base = base
    }

    fileprivate let base: AnalysisSettings
}


extension ValidatingAnalysisSettings: AnalysisSettings {
    var shouldFilterResults: Bool {
        get {
            return base.shouldFilterResults
        }

        set {
            base.shouldFilterResults = newValue
        }
    }


    var shouldHideNormalResults: Bool {
        get {
            return base.shouldFilterResults && base.shouldHideNormalResults
        }

        set {
            base.shouldHideNormalResults = newValue
        }
    }
}
