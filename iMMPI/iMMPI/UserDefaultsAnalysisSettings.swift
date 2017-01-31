import Foundation

final class UserDefaultsAnalysisSettings {
    let defaults: UserDefaults
    let filterKey: String
    let hideNormKey: String

    init(defaults: UserDefaults = .standard,
         filterKey: String = "com.immpi.defaults.analysis.shouldFilter",
         hideNormKey: String = "com.immpi.defaults.analysis.shouldHide") {
        self.defaults = defaults
        self.filterKey = filterKey
        self.hideNormKey = hideNormKey
    }
}


extension UserDefaultsAnalysisSettings: AnalysisSettings {
    var shouldFilterResults: Bool {
        get {
            return defaults.bool(forKey: filterKey)
        }

        set {
            defaults.set(newValue, forKey: filterKey)
            defaults.synchronize()
        }
    }


    var shouldHideNormalResults: Bool {
        get {
            return defaults.bool(forKey: hideNormKey)
        }

        set {
            defaults.set(newValue, forKey: hideNormKey)
            defaults.synchronize()
        }
    }
}
