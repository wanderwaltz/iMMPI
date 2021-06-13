import Foundation

public final class ValidatingAnalysisSettings {
    public init(_ base: AnalysisSettings) {
        self.base = base
    }

    fileprivate let base: AnalysisSettings
}

extension ValidatingAnalysisSettings: AnalysisSettings {
    public var shouldFilterResults: Bool {
        get { base.shouldFilterResults }
        set { base.shouldFilterResults = newValue }
    }

    public var shouldHideNormalResults: Bool {
        get { base.shouldFilterResults && base.shouldHideNormalResults }
        set { base.shouldHideNormalResults = newValue }
    }
}
