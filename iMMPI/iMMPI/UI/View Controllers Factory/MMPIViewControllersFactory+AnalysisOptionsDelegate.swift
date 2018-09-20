import Foundation

extension MMPIViewControllersFactory {
    final class AnalysisOptionsDelegate {}
}


extension MMPIViewControllersFactory.AnalysisOptionsDelegate: AnalysisOptionsViewControllerDelegate {
    func analysisOptionsViewControllerSettingsChanged(_ controller: AnalysisOptionsViewController) {
        NotificationCenter.default.post(name: .analysisSettingsChanged, object: nil)
    }
}


extension Notification.Name {
    static let analysisSettingsChanged = Notification.Name(rawValue: "com.immpi.notifications.analysisSettingsChanged")
}
