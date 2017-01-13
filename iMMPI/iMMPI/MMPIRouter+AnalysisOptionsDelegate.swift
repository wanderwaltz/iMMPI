import Foundation

extension MMPIRouter {
    // TODO: drop NSObject requirement when possible
    final class AnalysisOptionsDelegate: NSObject {}
}


extension MMPIRouter.AnalysisOptionsDelegate: AnalysisOptionsViewControllerDelegate {
    func analysisOptionsViewControllerSettingsChanged(_ controller: AnalysisOptionsViewController) {
        NotificationCenter.default.post(name: .analysisSettingsChanged, object: nil)
    }

    func analysisOptionsViewControllerPrintOptionSelected(_ controller: AnalysisOptionsViewController) {
        // TODO: implement
    }

    func analysisOptionsViewControllerEmailOptionSelected(_ controller: AnalysisOptionsViewController) {
        // TODO: implement
    }
}


extension Notification.Name {
    static let analysisSettingsChanged = Notification.Name(rawValue: "com.immpi.notifications.analysisSettingsChanged")
}
