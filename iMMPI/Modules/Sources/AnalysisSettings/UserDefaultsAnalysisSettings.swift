import Foundation

public final class UserDefaultsAnalysisSettings {
    let defaults: UserDefaults
    let filterKey: String
    let hideNormKey: String

    public convenience init() {
        self.init(defaults: .standard)
    }

    init(
        defaults: UserDefaults,
        filterKey: String = "com.immpi.defaults.analysis.shouldFilter",
        hideNormKey: String = "com.immpi.defaults.analysis.shouldHide"
    ) {
        self.defaults = defaults
        self.filterKey = filterKey
        self.hideNormKey = hideNormKey
    }
}

extension UserDefaultsAnalysisSettings: AnalysisSettings {
    public var shouldFilterResults: Bool {
        get { defaults.bool(forKey: filterKey) }

        set {
            defaults.set(newValue, forKey: filterKey)
            defaults.synchronize()
        }
    }

    public var shouldHideNormalResults: Bool {
        get { defaults.bool(forKey: hideNormKey) }

        set {
            defaults.set(newValue, forKey: hideNormKey)
            defaults.synchronize()
        }
    }
}
