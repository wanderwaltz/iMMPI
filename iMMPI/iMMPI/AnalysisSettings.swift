import Foundation

@objc protocol AnalysisSettings {
    /// Decides whether the analysis scores which are in the 'normal' 
    /// interval should be replaced by dashes '-' so that the 'out-of-norm' values are more visible.
    var shouldFilterResults: Bool { get set }

    /// Decides whether the analysis scores which are in the 'normal' 
    /// interval should be completely hidden from the analysis view.
    var shouldHideNormalResults: Bool { get set }
}
